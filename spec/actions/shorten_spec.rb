# frozen_string_literal: true

require 'spec_helper'

require './lib/actions/shorten'

module UrlShortener
  describe Actions::Shorten do
    subject { Actions::Shorten.new(url, custom_slug) }

    let(:url) { 'https://www.shopify.com' }
    let(:custom_slug) { 'marketing_is_great' }
    let(:slug) { 'BB' }
    let(:slug_number) { 81 }
    let(:link_params) do
      {url: url, custom_slug: custom_slug, slug: slug, slug_number: slug_number}
    end
    let(:link) { double('Link') }

    describe '#call' do
      it 'returns slug when successful' do
        expect(subject).to receive(:custom_slug_available?) { true }
        expect(Link)
          .to receive(:new)
          .with(link_params)
          .and_return(link)
        expect(link).to receive(:save)
        expect(link).to receive(:persisted?) { true }
        expect(subject.call).to eq(link)
      end

      it 'returns false when not' do
        expect(subject).to receive(:custom_slug_available?) { true }
        expect(Link)
          .to receive(:new)
          .with(link_params)
          .and_return(link)
        expect(link).to receive(:save)
        expect(link).to receive(:persisted?) { false }
        expect(subject.call).to be_falsey
      end

      it 'returns early if slug is taken' do
        expect(subject).to receive(:custom_slug_available?) { false }
        expect(subject.call).to be_falsey
      end

      it 'returns early if url is invalid' do
        expect(subject).to receive(:custom_slug_available?) { true }
        expect(subject).to receive(:url_invalid?) { true }
        expect(subject.call).to be_falsey
      end
    end # describe '#call'

    describe '#custom_slug_available?' do
      it 'returns true' do
        expect(Link).to receive(:find_by_both_slugs)
        expect(subject.custom_slug_available?).to be_truthy
      end

      it 'returns false' do
        expect(Link).to receive(:find_by_both_slugs).and_return(double('Link'))
        expect(subject.custom_slug_available?).to be_falsey
        expect(subject.message).to eq(
          "Redirect not created, slug #{custom_slug} taken")
      end
    end # describe '#custom_slug_available?'

    describe '#url_invalid?' do
      it 'returns true' do
        expect(subject.url_invalid?).to be_falsey
      end

      context 'with invalid url' do
        let(:url) { 'www.water.com' }
        it 'returns false' do
          expect(subject.url_invalid?).to be_truthy
          expect(subject.message).to eq(
            'Redirect not created, url has to start with http or https')
        end
      end
    end # describe '#url_invalid?'
  end # describe UrlShortener::Actions::Shorten
end # module UrlShortener
