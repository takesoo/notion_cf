# frozen_string_literal: true

module NotionCf
  # Notionのブロック、ページ、データベースを表す抽象クラス
  # ストラテジーパターン
  class Resource
    # unsupportedはNotion APIで作成できないので、テンプレートファイルには含めない
    AVAILABLE_TYPES = %w[paragraph to_do heading_1 heading_2 heading_3 bulleted_list_item
                         numbered_list_item toggle quote divider link_to_page callout image bookmark video
                         audio code file table_of_contents equation breadcrumb synced_block column_list
                         table child_database child_page].freeze

    attr_reader :object, :id, :type, :parent, :has_children, :attributes

    class << self
      # ファクトリーメソッド
      def build_resource(blueprint)
        return unless blueprint

        case blueprint[:type]
        when 'child_database'
          NotionCf::DatabaseResource.new(blueprint)
        when 'child_page'
          NotionCf::PageResource.new(blueprint)
        else
          NotionCf::BlockResource.new(blueprint)
        end
      end
    end

    def initialize(blueprint)
      @blueprint = blueprint
      @object = blueprint[:object]
      @id = blueprint[:id]
      @type = blueprint[:type]
      @parent = blueprint[:parent]
      @has_children = blueprint[:has_children]
      @attributes = blueprint[@type.to_sym]
    end

    def block?
      raise NotImplementedError
    end

    def deploy(_client, _parent_id = nil)
      raise NotImplementedError
    end

    def blueprint
      @blueprint if available_type?
    end

    def retrieve_additional_information(_client, _blueprints)
      raise NotImplementedError
    end

    private

    def available_type?
      AVAILABLE_TYPES.include?(@type)
    end
  end
end
