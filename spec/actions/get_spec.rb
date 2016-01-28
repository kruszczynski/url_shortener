# frozen_string_literal: true

require 'spec_helper'

require './url_shortener/actions/get'

module UrlShortener
  describe Actions::Get do
    subject { Actions::Get.new(slug) }

    let(:slug) { 'B=' }
    let(:link) { double('Link') }

    describe '.call' do
      it 'finds the link' do
        expect(Link)
          .to receive(:find_by_both_slugs)
          .with(slug)
          .and_return(link)
        expect(subject.call).to eq(link)
      end
    end # describe '.call'
  end # describe UrlShortener::Actions::Get
end # module UrlShortener
