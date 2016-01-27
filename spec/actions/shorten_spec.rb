require 'spec_helper'

require './url-shortener/storage/link'
require './url-shortener/actions/shorten'

describe UrlShortener::Actions::Shorten do
  subject { UrlShortener::Actions::Shorten.call(url, custom_slug) }

  let(:url) { 'https://www.shopify.com' }
  let(:custom_slug) { 'marketing_is_great' }
  let(:link) { UrlShortener::Storage::Link.new('slug', url, custom_slug) }

  describe '.call' do
    it 'returns slug' do
      expect(UrlShortener::Storage::Basic)
        .to receive(:save)
        .with(url, custom_slug)
        .and_return(link)
      expect(subject).to eq(custom_slug)
    end
  end
end # describe UrlShortener::Actions::Shorten
