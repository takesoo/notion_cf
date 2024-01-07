# frozen_string_literal: true

module NotionCf
  # Notion API client
  class NotionApiClient
    def initialize
      @client = Notion::Client.new(token: ENV['NOTION_API_TOKEN'])
    end

    def block_children(block_id:)
      children = retrieve_children(block_id)
      children.filter_map do |child|
        resource = NotionCf::Resource.build_resource(child)
        resource.retrieve_additional_information(self, children)
      end
      children
    end

    def retrieve_children(block_id)
      @client.block_children(block_id:)[:results]
    end

    def page(page_id:)
      @client.page(page_id:)
    end

    def database(database_id:)
      @client.database(database_id:)
    end

    def block_append_children(block_id:, children:)
      @client.block_append_children(block_id:, children:)
    end

    def create_database(parameter)
      @client.create_database(parameter)
    end

    def create_page(parameter)
      @client.create_page(parameter)
    end

    def update_block(id:, parameter:)
      @client.update_block(block_id: id, **parameter)
    end

    def update_database(database_id:, parameter:)
      @client.update_database(database_id:, **parameter)
    end

    def update_page(page_id:, parameter:)
      @client.update_page(page_id:, **parameter)
    end
  end
end
