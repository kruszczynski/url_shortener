require 'spec_helper'

require './url-shortener/storage/link'
require './url-shortener/actions/get'

describe UrlShortener::Actions::Get do
  subject { UrlShortener::Actions::Get.call(slug) }
  let(:slug) { 'slug' }
  let(:link) do
    UrlShortener::Storage::Link.new(slug, 'https://www.youtube.com', nil)
  end

  describe '.call' do
    it 'finds the link' do
      expect(UrlShortener::Storage::Basic)
        .to receive(:find)
        .with(slug)
        .and_return(link)
      expect(subject).to eq(link)
    end
  end # describe '.call'
end # describe UrlShortener::Actions::Get
