module NotionCf
  # block, page, databaseなどリソースの集合
  # FirstClassCollectionパターン(?)
  class Resources
    def initialize(page_id:)
      @client = NotionCf::NotionApiClient.new
      @page_id = page_id
    end

    def deploy(blueprints)
      block_blueprints = []
      blueprints.each do |blueprint|
        if blueprint[:type] != 'child_database'
          block_blueprints << blueprint
          next
        end
        append_up_to_now(block_blueprints, blueprint)
      end
      append_children(block_blueprints)
    end

    private

    def append_children(block_blueprints)
      return if block_blueprints.empty?

      @client.block_append_children(block_id: @page_id, children: block_blueprints)
    end

    def append_up_to_now(block_blueprints, database_blueprint)
      append_children(block_blueprints)
      @client.create_database(database_blueprint)
      block_blueprints.clear
    end
  end
end
