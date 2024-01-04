# frozen_string_literal: true

module NotionCf
  # BlockResource class
  class BlockResource < Resource
    def block?
      true
    end

    def deploy(client, parent_id = nil)
      children = [@blueprint.slice(@type.to_sym)]
      block_id = parent_id || @parent[:id]
      client.block_append_children(block_id:, children:)
    end

    def create(_client) = nil

    def retrieve_additional_information(client, blueprints)
      return unless @has_children

      children = client.retrieve_children(@id)
      parent = blueprints.detect { |h| h[:id] == @id }
      block_type = @type.to_sym
      parent[block_type][:children] = children
      children.filter_map do |child|
        next unless (resource = NotionCf::Resource.build_resource(child)).has_children

        resource.retrieve_additional_information(client, parent[block_type][:children])
      end
    end
  end
end
