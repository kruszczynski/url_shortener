# frozen_string_literal: true

require 'spec_helper'

require './lib/services/shared_logger'

module UrlShortener
  describe SharedLogger do
    subject { dummy.new }
    let(:dummy) { Class.new { include SharedLogger } }
    let(:logger) { double('Logger') }

    describe '#log_info' do
      it 'logs the message' do
        expect(Logger).to receive(:new) { logger }
        expect(logger).to receive(:info).with('message')
        expect(App.settings.log_output).to receive(:flush)
        subject.log_info 'message'
      end
    end
  end # describe SharedLogger
end # module UrlShortener
