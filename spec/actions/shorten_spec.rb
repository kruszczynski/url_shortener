# frozen_string_literal: true

require 'spec_helper'

require './url_shortener/actions/shorten'

module UrlShortener
  describe Actions::Shorten do
    subject { Actions::Shorten.call(url, custom_slug) }

    let(:url) { 'https://www.shopify.com' }
    let(:custom_slug) { 'marketing_is_great' }
    let(:slug) { 'W44' }
    let(:slug_number) { 145_336 }
    let(:link_params) do
      {url: url, custom_slug: custom_slug, slug: slug, slug_number: slug_number}
    end
    let(:link) { double('Link', link_params) }

    describe '.call' do
      it 'returns slug when successful' do
        expect(SlugNumber).to receive(:latest) { slug_number }
        expect(SlugGenerator).to receive(:generate).with(slug_number) { slug }
        expect(Link)
          .to receive(:new)
          .with(link_params)
          .and_return(link)
        expect(link).to receive(:save)
        expect(link).to receive(:persisted?) { true }
        expect(subject).to eq(link)
      end

      it 'returns false when not' do
        expect(SlugNumber).to receive(:latest) { slug_number }
        expect(SlugGenerator).to receive(:generate).with(slug_number) { slug }
        expect(Link)
          .to receive(:new)
          .with(link_params)
          .and_return(link)
        expect(link).to receive(:save)
        expect(link).to receive(:persisted?) { false }
        expect(subject).to be_falsey
      end
    end
  end # describe UrlShortener::Actions::Shorten
end # module UrlShortener
