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
        if blueprint[:type] != 'child_database' && blueprint[:type] != 'child_page'
          block_blueprints << blueprint
          next
        end
        append_up_to_now(block_blueprints, blueprint)
      end
      block_append_children(block_blueprints)
    end

    private

    def block_append_children(block_blueprints)
      return if block_blueprints.empty?

      @client.block_append_children(block_id: @page_id, children: block_blueprints)
    end

    def append_up_to_now(block_blueprints, current_blueprint)
      block_append_children(block_blueprints)
      case current_blueprint[:type]
      when 'child_database'
        @client.create_database(current_blueprint)
      when 'child_page'
        @client.create_page(current_blueprint)
      else
        raise "unknown type: #{current_blueprint[:type]}"
      end
      block_blueprints.clear
    end
  end
end
