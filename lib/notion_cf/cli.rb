require "notion_cf"
require "thor"

module NotionCf
  class CLI < Thor
    desc "version", "Prints the version"
    def version
      puts NotionCf::VERSION
    end

    desc "generate", "Generate a new Notion page"
    def generate
      puts "Generating a new Notion page..."
    end
  end
end
