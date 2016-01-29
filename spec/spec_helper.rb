# frozen_string_literal: true

require 'bundler'
Bundler.setup

ENV['RACK_ENV'] = 'test'

# necessary for testing of couchrest without sinatra required
require 'yaml'
require 'rack/test'
require 'rspec'
require './url_shortener/models/link'

require './url_shortener/services/slug_number'

# The `.rspec` file also contains a few flags that are not defaults but that
# users commonly want.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # since couchrest's configuration is strongly Rails-biased
  # This has to be set manually here
  CouchRest::Model::Base.configure do |couchrest_config|
    couchrest_config.environment = :test
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    # clean database before every test
    UrlShortener::Link.all.map(&:destroy)

    # set etcd counter to 0
    Etcd.client(host: ENV['ETCD_PORT_2379_TCP_ADDR'], port: 2379)
      .set('/url_shortener/test/counter1', value: 80)

    # start etcd watch
    UrlShortener::SlugNumber.instance.start
  end

  config.order = :random
end
