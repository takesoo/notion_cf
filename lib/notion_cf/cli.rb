require "notion_cf"
require "thor"

module NotionCf
  class CLI < Thor
    desc "version", "Prints the version"
    def version
      puts NotionCf::VERSION
    end
  end
end
