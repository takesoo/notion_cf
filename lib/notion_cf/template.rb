require 'yaml'
require 'json'
require 'pry-byebug'

module NotionCf
  # Template class
  class Template
    # rubocop:disable Naming/VariableNumber
    # unsupportedはNotion APIで作成できないので、テンプレートファイルには含めない
    AVAILABLE_TYPES = %i[paragraph to_do heading_1 heading_2 heading_3 bulleted_list_item
                         numbered_list_item toggle quote divider link_to_page callout image bookmark video
                         audio code file table_of_contents equation breadcrumb synced_block column_list
                         table child_database child_page].freeze
    AVAILABLE_KEYS = (%i[object type parent] + AVAILABLE_TYPES).freeze
    # rubocop:enable Naming/VariableNumber
    def initialize(hash: nil, page_id: nil, file: nil)
      @page_id = page_id if page_id
      @hash = hash if hash
      return unless file

      string_key_hash = YAML.load_file("templates/#{file}")
      @hash = JSON.parse(string_key_hash.to_json, symbolize_names: true)
    end

    def create
      yaml = YAML.dump(@hash).gsub(%r{!ruby/(\w|:)*}, '') # ハッシュをyamlに変換する際に出力される!ruby/hash:Notion::Blockみたいな文字列を削除する
      file_path = "templates/#{@page_id}.yaml"
      File.open(file_path, 'w') { |file| file.write(yaml) }
      file_path
    end

    # yamlテンプレートからhash形式の設計図を生成する
    def blueprints
      available_types_string = AVAILABLE_TYPES.map(&:to_s)
      @hash.filter_map do |child|
        child.slice(*AVAILABLE_KEYS) if available_block_type?(child, available_types_string)
      end
    end

    private

    def available_block_type?(child, available_types_string)
      return false if linked_database?(child) # linked_databaseはNotion APIで作成できないので、request_bodyには含めない
      return true if available_block?(child, available_types_string)

      false
    end

    def available_block?(child, available_types_string)
      available_types_string.include?(child[:type])
    end

    # child_databaseのtitleが空の場合は、linked_databaseとして扱う
    def linked_database?(child)
      child[:type] == 'child_database' && child[:child_database][:title].empty?
    end
  end
end
