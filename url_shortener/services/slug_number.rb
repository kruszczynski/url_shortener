# frozen_string_literal: true

require 'singleton'
require 'etcd'

require './url_shortener/app'

module UrlShortener
  class SlugNumber
    include Singleton

    attr_reader :counter

    def initialize
      @client = Etcd.client(
        host: ENV['ETCD_PORT_2379_TCP_ADDR'], port: 2379)
    end

    def start
      @counter = @client.get(counter_key).value.to_i
      Thread.new { watch }
    end

    def latest
      @client.test_and_set(
        counter_key, value: counter + 1, prevValue: counter)
      counter
    end

    private

    def counter_key
      "/url_shortener/#{App.environment}/counter1"
    end

    def watch
      loop do
        begin
          @counter = Integer(@client.watch(counter_key).value.to_i)
        rescue Etcd::Error => error
          # here logging should take place
          puts error
        end
      end
    end
  end # class SlugNumber
end # module UrlShortener
