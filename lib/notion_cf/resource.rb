module NotionCf
  # Notionのブロック、ページ、データベースを表す抽象クラス
  # ストラテジーパターン
  class Resource
    attr_reader :blueprint

    class << self
      # ファクトリーメソッド
      def build_resource(blueprint)
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
      @type = blueprint[:type]
      @parent = blueprint[:parent]
      @attributes = blueprint[@type.to_sym]
    end

    def block?
      raise NotImplementedError
    end

    def create(_client)
      raise NotImplementedError
    end
  end
end
