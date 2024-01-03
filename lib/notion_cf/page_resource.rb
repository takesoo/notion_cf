module NotionCf
  # PageResource class
  class PageResource < Resource
    def block?
      false
    end

    def create(client)
      parameter = @attributes.except(:request_id, :title)
      client.create_page(parameter)
    end
  end
end
