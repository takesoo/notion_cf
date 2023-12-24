require 'yaml'
require 'json'

module NotionCf
  # Template class
  class Template
    # rubocop:disable Naming/VariableNumber
    # TODO: child_page table child_database
    AVAILABLE_TYPES = %i[paragraph to_do heading_1 heading_2 heading_3 bulleted_list_item
                         numbered_list_item toggle quote divider link_to_page callout image bookmark video
                         audio code file table_of_contents equation unsupported breadcrumb synced_block column_list
                         child_database].freeze
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
      yaml = YAML.dump(@hash).gsub(/ !ruby.*/, '') # ハッシュをyamlに変換する際に、!ruby/hash:Notion::Blockという形式で出力されるので、これを削除する
      File.open("templates/#{@page_id}.yaml", 'w') { |file| file.write(yaml) }
    end

    def request_body
      # binding.pry
      available_types_string = AVAILABLE_TYPES.map(&:to_s)
      @hash[:results].filter_map do |child|
        child.slice(*AVAILABLE_KEYS) if available_types_string.include?(child[:type])
      end
    end
  end
end
