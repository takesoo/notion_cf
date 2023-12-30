require 'yaml'
require 'json'
require 'pry-byebug'

module NotionCf
  # Template class
  class Template
    # rubocop:disable Naming/VariableNumber
    # TODO: child_page child_database
    # unsupportedはNotion APIで作成できないので、テンプレートファイルには含めない
    AVAILABLE_TYPES = %i[paragraph to_do heading_1 heading_2 heading_3 bulleted_list_item
                         numbered_list_item toggle quote divider link_to_page callout image bookmark video
                         audio code file table_of_contents equation breadcrumb synced_block column_list
                         table].freeze
    AVAILABLE_KEYS = (%i[object type] + AVAILABLE_TYPES).freeze
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
      File.open("templates/#{@page_id}.yaml", 'w') { |file| file.write(yaml) }
      puts "created templates/#{@page_id}.yaml"
    end

    def request_body
      available_types_string = AVAILABLE_TYPES.map(&:to_s)
      @hash.filter_map do |child|
        child.slice(*AVAILABLE_KEYS) if available_types_string.include?(child[:type])
      end
    end
  end
end
