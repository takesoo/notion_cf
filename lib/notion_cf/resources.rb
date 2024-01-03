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
        resource = NotionCf::Resource.build_resource(blueprint)
        if resource.block?
          add_blueprints(resource, block_blueprints)
          next
        end
        append_up_to_now(block_blueprints, resource)
      end
      block_append_children(block_blueprints)
    end

    private

    def block_append_children(block_blueprints)
      return if block_blueprints.empty?

      @client.block_append_children(block_id: @page_id, children: block_blueprints)
    end

    def append_up_to_now(block_blueprints, resource)
      block_append_children(block_blueprints)
      resource.create(@client)
      clear_blueprints(block_blueprints)
    end

    def add_blueprints(resource, block_blueprints)
      block_blueprints << resource.blueprint
    end

    def clear_blueprints(block_blueprints)
      block_blueprints.clear
    end
  end
end
