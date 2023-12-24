require 'notion_cf'
require 'thor'
require_relative 'notion_api_client'
require_relative 'template'
require 'pry-byebug'

module NotionCf
  # CLI class
  class CLI < Thor
    desc 'version', 'Prints the version'
    def version
      puts NotionCf::VERSION
    end

    desc 'deploy PAGE_ID TEMPLATE_FILE', 'Generate a new Notion page'
    def deploy(page_id, template_file)
      pp children = Template.new(file: template_file).request_body
      client = Notion::Client.new(token: ENV['NOTION_API_TOKEN'])
      pp client.block_append_children(block_id: page_id, children:)
      generate(page_id)
    end

    desc 'generate PAGE_ID', 'Generate yaml file from Notion page'
    def generate(page_id)
      children = NotionCf::NotionApiClient.new.block_children(block_id: page_id)
      children.filter_map do |child|
        retrieve_children(child, children) if child[:has_children]
      end
      NotionCf::Template.new(hash: children, page_id:).create
    end

    private

    def retrieve_children(block, blocks)
      children = NotionApiClient.new.block_children(block_id: block[:id])
      parent = blocks.detect { |h| h[:id] == block[:id] }
      block_type = block[:type].to_sym
      parent[block_type] = children
      children.filter_map do |child|
        retrieve_children(child, parent[block_type]) if child[:has_children]
      end
    end
  end
end
