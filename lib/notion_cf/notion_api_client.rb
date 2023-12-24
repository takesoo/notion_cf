require 'notion-ruby-client'
require 'dotenv/load'

module NotionCf
  # Notion API client
  class NotionApiClient
    def initialize
      @client = Notion::Client.new(token: ENV['NOTION_API_TOKEN'])
    end

    # def page(page_id:)
    #   @client.page(page_id: page_id)
    # end

    def block_children(block_id:)
      @client.block_children(block_id:)
    end
  end
end
