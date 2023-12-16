require "yaml"
require "json"

module NotionCf
  # Template class
  class Template
    def initialize(hash:, page_id:)
      @hash = hash
      @page_id = page_id
    end

    def create
      yaml = YAML.dump(@hash).gsub(/ !ruby.*/, "") # ハッシュをyamlに変換する際に、!ruby/hash:Notion::Blockという形式で出力されるので、これを削除する
      File.open("templates/#{@page_id}.yaml", "w") { |file| file.write(yaml) }
    end
  end
end
