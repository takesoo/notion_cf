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

    def deploy(client, parent_id)
      return if linked_database?

      unless @id.nil?
        update(client)
        return
      end

      create(client, parent_id)
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

    private

    def create(client, parent_id)
      puts 'create database'
      parent = { parent: { page_id: parent_id } }
      parameter = @attributes.except(:request_id).merge(parent)
      client.create_database(parameter)
    end

    def update(client)
      puts "update database #{@id}"
      parameter = @attributes.except(:request_id, :parent, :created_by, :last_edited_by, :last_edited_time, 
                                     :created_time)
      client.update_database(database_id: @id, parameter:)
    end
  end
end
