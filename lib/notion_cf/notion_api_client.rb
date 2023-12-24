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
      end
      children
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
  end
end