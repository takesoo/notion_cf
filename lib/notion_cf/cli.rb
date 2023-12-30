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
      children = Template.new(file: template_file).request_body
      client = Notion::Client.new(token: ENV['NOTION_API_TOKEN'])
      client.block_append_children(block_id: page_id, children:)
      generate(page_id)
    end

    desc 'generate PAGE_ID', 'Generate yaml file from Notion page'
    def generate(page_id)
      children = NotionCf::NotionApiClient.new.block_children(block_id: page_id)
      NotionCf::Template.new(hash: children, page_id:).create
    end
  end
end
