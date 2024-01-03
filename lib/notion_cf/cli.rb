require 'notion_cf'
require 'thor'
require 'notion-ruby-client'
require 'dotenv/load'
require_relative 'notion_api_client'
require_relative 'template'
require_relative 'resources'
require_relative 'resource'
require_relative 'block_resource'
require_relative 'page_resource'
require_relative 'database_resource'
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
      blueprints = Template.new(file: template_file).blueprints
      NotionCf::Resources.new(page_id:).deploy(blueprints)
      generate(page_id)
    end

    desc 'generate PAGE_ID', 'Generate yaml file from Notion page'
    def generate(page_id)
      children = NotionCf::NotionApiClient.new.block_children(block_id: page_id)
      file_path = NotionCf::Template.new(hash: children, page_id:).create
      puts "created #{file_path}"
    end
  end
end
