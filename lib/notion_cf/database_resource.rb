module NotionCf
  # BlockResource class
  class DatabaseResource < Resource
    def block?
      false
    end

    def linked_database?
      @attributes[:title].empty?
    end

    def create(client)
      parameter = @attributes.except(:request_id)
      client.create_database(parameter)
    end
  end
end
