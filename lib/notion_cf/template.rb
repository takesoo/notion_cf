# frozen_string_literal: true

module NotionCf
  # Template class
  class Template
    attr_reader :blueprints

    class << self
      def build_from_file(file:)
        raise 'file is required' unless file

        string_key_hash = YAML.load_file("templates/#{file}")
        blueprints = JSON.parse(string_key_hash.to_json, symbolize_names: true)
        new(blueprints:)
      end
    end

    def initialize(blueprints: [])
      @blueprints = blueprints
    end

    def create(page_id)
      # ハッシュをyamlに変換する際に出力される!ruby/hash:Notion::Blockみたいな文字列を削除する
      yaml = YAML.dump(blueprints).gsub(%r{!ruby/(\w|:)*}, '')
      file_path = "templates/#{page_id}.yaml"
      File.open(file_path, 'w') { |file| file.write(yaml) }
      file_path
    end
  end
end
