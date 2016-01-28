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

    describe '#returnable_slug' do
      it 'returns regular slug' do
        expect(link.returnable_slug).to eq(slug)
      end
      it 'returns custom slug when present' do
        expect(link_with_custom_slug.returnable_slug).to eq(custom_slug)
      end
    end
  end # describe Link
end # module UrlShortener
