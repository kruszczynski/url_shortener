# frozen_string_literal: true

require 'spec_helper'

require './url_shortener/services/slug_number'

module UrlShortener
  describe SlugNumber do
    subject { SlugNumber.instance }

    context 'counter' do
      it 'starts with 80' do
        expect(subject.counter).to eq(80)
      end

      it 'counter is updated when etcd is changed' do
        Etcd.client(host: ENV['ETCD_PORT_2379_TCP_ADDR'], port: 2379)
          .set('/url_shortener/test/counter1', value: 84)
        expect(subject.counter).to eq(84)
      end
    end

    context '#latest' do
      it 'returns 81' do
        expect(subject.latest).to eq(81)
      end
    end
  end # describe EtcdClient
end # module UrlShortener
