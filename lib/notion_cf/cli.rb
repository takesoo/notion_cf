# frozen_string_literal: true

module NotionCf
  # CLI class
  class CLI < Thor
    desc 'version', 'Prints the version'
    def version
      puts NotionCf::VERSION
    end

    desc 'deploy PAGE_ID TEMPLATE_FILE', 'Generate a new Notion page'
    def deploy(page_id, template_file)
      blueprints = Template.build_from_file(file: template_file).blueprints
      NotionCf::Resources.new(page_id:).deploy(blueprints)
      generate(page_id)
    end

    desc 'generate PAGE_ID', 'Generate yaml file from Notion page'
    def generate(page_id)
      resources = NotionCf::Resources.new(page_id:)
      resources.retrieve
      file_path = NotionCf::Template.new(blueprints: resources.blueprints).create(page_id)
      puts "created #{file_path}"
    end
  end
end
