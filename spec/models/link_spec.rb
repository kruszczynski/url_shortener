# frozen_string_literal: true

require 'spec_helper'

module UrlShortener
  describe Link do
    let(:link_params) do
      {url: 'https://www.google.com', slug_number: 80, slug: slug}
    end
    let(:slug) { 'BA' }
    let(:custom_slug) { 'getitcheaper' }
    let(:link) { Link.new(link_params) }

    let(:link_with_custom_slug) do
      Link.new(link_params.merge(custom_slug: custom_slug))
    end

    describe '.find_by_both_slugs' do
      let(:candidate_slug) { 'bestcheappills' }
      let(:link) { Link.new }
      let(:find_call) { Link.find_by_both_slugs(candidate_slug) }

      it 'retuns link whose slug matches' do
        expect(Link).to receive(:find_by_slug)
          .with(candidate_slug)
          .and_return(link)
        expect(Link).to_not receive(:find_by_custom_slug)
        expect(find_call).to eq(link)
      end

      it 'retuns link whose custom_slug matches' do
        expect(Link).to receive(:find_by_slug)
          .with(candidate_slug)
        expect(Link).to receive(:find_by_custom_slug)
          .with(candidate_slug)
          .and_return(link)
        expect(find_call).to eq(link)
      end
    end # describe '.find_by_both_slugs'

    describe '#returnable_slug' do
      it 'returns regular slug' do
        expect(link.returnable_slug).to eq(slug)
      end
      it 'returns custom slug when present' do
        expect(link_with_custom_slug.returnable_slug).to eq(custom_slug)
      end
    end # describe '#returnable_slug'
  end # describe Link
end # module UrlShortener
