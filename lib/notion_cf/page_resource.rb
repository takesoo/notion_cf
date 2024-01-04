# frozen_string_literal: true

module NotionCf
  # PageResource class
  class PageResource < Resource
    def block?
      false
    end

    def deploy(client, parent_id)
      parent = { parent: { page_id: parent_id } }
      parameter = @attributes.except(:request_id, :title).merge(parent)
      client.create_page(parameter)
    end

    def retrieve_additional_information(client, blueprints)
      page_detail = client.page(page_id: @id)
      parent = blueprints.detect { |h| h[:id] == @id }
      parent[:child_page].merge!(page_detail)
    end
  end
end
