# frozen_string_literal: true

require 'notion_cf'
require 'thor'
require 'yaml'
require 'json'
require 'notion-ruby-client'
require 'dotenv/load'
require_relative 'notion_cf/version'
require_relative 'notion_cf/cli'
require_relative 'notion_cf/notion_api_client'
require_relative 'notion_cf/template'
require_relative 'notion_cf/resources'
require_relative 'notion_cf/resource'
require_relative 'notion_cf/block_resource'
require_relative 'notion_cf/page_resource'
require_relative 'notion_cf/database_resource'
require 'pry-byebug'

module NotionCf
  class Error < StandardError; end
  # Your code goes here...
end
