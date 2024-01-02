require 'notion-ruby-client'
require 'dotenv/load'

module NotionCf
  # Notion API client
  class NotionApiClient
    def initialize
      @client = Notion::Client.new(token: ENV['NOTION_API_TOKEN'])
    end

    def block_children(block_id:)
      children = retrieve_children(block_id)
      children.filter_map do |child|
        retrieve_grand_children(child, children) if child[:has_children]
        retrieve_database(child, children) if child[:type] == 'child_database' && !child[:child_database][:title].empty?
      end
      children
    end

    def block_append_children(block_id:, children:)
      @client.block_append_children(block_id:, children:)
    end

    def create_database(blueprint)
      parameter = blueprint[:child_database].except(:request_id)
      @client.create_database(parameter)
    end

    private

    def retrieve_children(block_id)
      @client.block_children(block_id:)[:results]
    end

    def retrieve_grand_children(block, blocks)
      children = retrieve_children(block[:id])
      parent = blocks.detect { |h| h[:id] == block[:id] }
      block_type = block[:type].to_sym
      parent[block_type][:children] = children
      children.filter_map do |child|
        retrieve_grand_children(child, parent[block_type][:children]) if child[:has_children]
      end
    end

    def retrieve_database(block, blocks)
      database_detail = @client.database(database_id: block[:id])
      parent = blocks.detect { |h| h[:id] == block[:id] }
      parent[:child_database].merge!(database_detail)
    end
  end
end
