# frozen_string_literal: true

module NotionCf
  # BlockResource class
  class BlockResource < Resource
    def block?
      true
    end

    def deploy(client, parent_id = nil)
      unless @id.nil?
        update(client)
        return
      end

      create(client, parent_id)
    end

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

    private

    def create(client, parent_id = nil)
      puts "create #{@type}"
      children = [@blueprint.slice(@type.to_sym)]
      block_id = parent_id || @parent[:id]
      client.block_append_children(block_id:, children:)
    end

    def update(client)
      # TODO: 既存ブロックと差異がなければ更新しないようにする
      puts "update #{@type} #{@id}"
      parameter = format_parameter
      client.update_block(id: @id, parameter:)
      return unless @has_children

      children = @blueprint[@type.to_sym][:children]
      children.each do |child|
        resource = NotionCf::Resource.build_resource(child)
        resource.deploy(client, @id)
      end
    end

    # TODO: これ以上条件分岐が複雑になるならストラテジパターンにする
    def format_parameter
      parameter = extract_parameter
      clean_attrs(parameter)
    end

    def extract_parameter
      if %w[column column_list].include?(@type)
        @blueprint.slice(:archived)
      else
        @blueprint.slice(@type.to_sym, :archived)
      end
    end

    def clean_attrs(parameter)
      attrs = parameter[@type.to_sym]
      if attrs && !attrs.empty?
        parameter[@type.to_sym] = parameter[@type.to_sym].except(:children, :table_width)
        parameter[@type.to_sym] = parameter[@type.to_sym].except(:type) if %w[image video file].include?(@type)
      end
      parameter
    end
  end
end
