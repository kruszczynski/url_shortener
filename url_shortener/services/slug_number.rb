# frozen_string_literal: true

require 'singleton'
require 'etcd'

require './url_shortener/app'
require './url_shortener/services/shared_logger'

module UrlShortener
  # SlugNumber connects to etcd cluster to synchronise slug counter.
  # In case of collision it will ask Etcd for latest number and re-attempt
  # incrementation. Etcd guarantees atomicity of the counter
  #
  # Uniqueness is important because based on the counter we generate the slug

  class SlugNumber
    include Singleton
    include SharedLogger

    attr_reader :counter

    def initialize
      @client = Etcd.client(
        host: ENV['ETCD_PORT_2379_TCP_ADDR'], port: 2379)
    end

    def start
      update_counter
      Thread.new { watch }
    end

    def latest
      @counter = @client.test_and_set(
        counter_key, value: counter + 1, prevValue: counter).value.to_i
    rescue Etcd::TestFailed
      log_info "Etcd::TestFailed for counter: #{counter}"
      update_counter
      latest
    end

    private

    # this method smells of :reek:UtilityFunction
    def counter_key
      "/url_shortener/#{App.environment}/counter1"
    end

    def watch
      loop do
        begin
          @counter = Integer(@client.watch(counter_key).value.to_i)
        rescue Etcd::Error => error
          log_info error
        end
      end
    end

    def update_counter
      @counter = @client.get(counter_key).value.to_i
    end
  end # class SlugNumber
end # module UrlShortener
