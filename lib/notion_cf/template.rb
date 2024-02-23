# frozen_string_literal: true

module NotionCf
  # Template class
  class Template
    attr_reader :blueprints

    class << self
      def build_from_file(file_path:)
        raise ArgumentError, 'file_path is required' unless file_path

        string_key_hash = YAML.load_file(file_path)
        blueprints = JSON.parse(string_key_hash.to_json, symbolize_names: true)
        new(blueprints:)
      end
    end

    def initialize(blueprints: [])
      @blueprints = blueprints
    end

    def create(resource_id)
      # ハッシュをyamlに変換する際に出力される!ruby/hash:Notion::Blockみたいな文字列を削除する
      yaml = YAML.dump(blueprints).gsub(%r{!ruby/(\w|:)*}, '')
      dir = blueprints.is_a?(Array) ? 'page_contents' : blueprints['object']
      file_path = "templates/#{dir}/#{resource_id}.yaml"
      File.open(file_path, 'w') { |file| file.write(yaml) }
      file_path
    end
  end
end
