# frozen_string_literal: true

module NotionCf
  # PageResource class
  class PageResource < Resource
    def block?
      false
    end

    def deploy(client, parent_id)
      unless @id.nil?
        update(client)
        return
      end
      create(client, parent_id)
    end

    def retrieve_additional_information(client, blueprints)
      page_detail = client.page(page_id: @id)
      parent = blueprints.detect { |h| h[:id] == @id }
      parent[:child_page].merge!(page_detail)
    end

    private

    def create(client, parent_id)
      puts 'create page'
      parent = { parent: { page_id: parent_id } }
      parameter = @attributes.except(:request_id, :title).merge(parent)
      client.create_page(parameter)
    end

    def update(client)
      puts "update page #{@id}"
      parameter = @attributes.except(:request_id, :title)
      client.update_page(page_id: @id, parameter:)
    end
  end
end
