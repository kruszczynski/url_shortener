# frozen_string_literal: true

require './lib/app'

module UrlShortener
  # SharedLogger is a simple module to make logging
  # across variuos objects easier

  module SharedLogger
    def log_info(message)
      logger.info message
      output.flush
    end

    private

    def logger
      @logger ||= Logger.new(output)
    end

    # this method smells of :reek:UtilityFunction
    def output
      App.settings.log_output
    end
  end
end # module UrlShortener
