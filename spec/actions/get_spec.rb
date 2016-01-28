# frozen_string_literal: true

require 'spec_helper'

require './url_shortener/actions/get'

module UrlShortener
  describe Actions::Get do
    subject { Actions::Get.call(slug) }

    let(:slug) { '5' }
    let(:url) { 'https://www.shopify.com' }
    let(:custom_slug) { 'marketing_is_great' }
    let(:params) { {url: url, custom_slug: custom_slug, slug: slug} }
    let(:link) { double('Link', params) }

    describe '.call' do
      it 'finds the link' do
        expect(Link)
          .to receive(:by_slug)
          .with(keys: [slug])
          .and_return(double(first: link))
        expect(subject).to eq(link)
      end
    end # describe '.call'
  end # describe UrlShortener::Actions::Get
end # module UrlShortener
