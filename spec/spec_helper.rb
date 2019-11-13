# frozen_string_literal: true

require 'factory_bot'
require 'factory_bot_rails'
require 'support/common_functions'

RSpec.configure do |config|
  include CommonFunctions

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    config.include FactoryBot::Syntax::Methods
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
