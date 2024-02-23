# frozen_string_literal: true

module NotionCf
  # CLI class
  class CLI < Thor
    desc 'version', 'Prints the version'
    def version
      puts NotionCf::VERSION
    end

    desc 'deploy PAGE_ID TEMPLATE_FILE_PATH', 'Generate a new Notion page'
    def deploy(page_id, template_file_path)
      blueprints = Template.build_from_file(file_path: template_file_path).blueprints
      NotionCf::Resources.new(page_id:).deploy(blueprints)
      generate(page_id)
    end

    desc 'generate_page_contents_template PAGE_ID', 'Generate yaml file from Notion page'
    def generate_page_contents_template(page_id)
      resources = NotionCf::Resources.new(page_id:)
      resources.retrieve
      file_path = NotionCf::Template.new(blueprints: resources.blueprints).create(page_id)
      puts "created #{file_path}"
    end

    desc 'generate_database_template DATABASE_ID', 'Generate yaml file from Notion database'
    def generate_database_template(database_id)
      response = NotionCf::NotionApiClient.new.database(database_id:)
      database = NotionCf::DatabaseResource.new(response)
      file_path = NotionCf::Template.new(blueprints: database.blueprint).create(database_id)
      puts "created #{file_path}"
    end
  end
end
