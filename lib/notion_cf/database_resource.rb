# frozen_string_literal: true

module NotionCf
  # BlockResource class
  class DatabaseResource < Resource
    def block?
      false
    end

    # child_databaseのtitleが空の場合は、linked_databaseとして扱う
    def linked_database?
      @attributes[:title].empty?
    end

    def create(client)
      parameter = @attributes.except(:request_id)
      client.create_database(parameter)
    end

    def available_type?
      return false if linked_database? # linked_databaseはNotion APIで作成できないので除外する

      super
    end

    def retrieve_additional_information(client, blueprints)
      return if linked_database?

      database_detail = client.database(database_id: @id)
      parent = blueprints.detect { |h| h[:id] == @id }
      parent[:child_database].merge!(database_detail)
    end
  end
end
