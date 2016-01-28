require 'spec_helper'

require './url-shortener/app'

module UrlShortener
  describe App do
    include Rack::Test::Methods

    def app
      App
    end

    describe 'GET to /:slug' do
      shared_examples_for 'redirects' do |slug, url|
        it 'is a redirect with 301 status' do
          get "/#{slug}"
          expect(last_response.status).to eq(301)
        end

        it "redirects to #{url}" do
          get "/#{slug}"
          expect(last_response.location).to eq(url)
        end
      end

      context 'auto generated slugs' do
        before do
          Link.new(
            url: 'https://www.google.com', slug_number: 80, slug: 'BA').save
          Link.new(
            url: 'https://www.facebook.com', slug_number: 81, slug: 'BB').save
          Link.new(
            url: 'https://www.twitter.com', slug_number: 159, slug: 'B=').save
          Link.new(
            url: 'https://www.shopify.com', slug_number: 161, slug: 'CB').save
          Link.new(
            url: 'https://www.github.com', slug_number: 6399, slug: '==').save
        end

        it_behaves_like 'redirects', 'BA', 'https://www.google.com'
        it_behaves_like 'redirects', 'BB', 'https://www.facebook.com'
        it_behaves_like 'redirects', 'B=', 'https://www.twitter.com'
        it_behaves_like 'redirects', 'CB', 'https://www.shopify.com'
        it_behaves_like 'redirects', '==', 'https://www.github.com'

        it 'returns a 404 for not existing slug' do
          get '/fightforyourrighttoparty'
          expect(last_response.status).to eq(404)
        end
      end # context 'auto generated slugs'

      context 'custom slugs' do
      end
    end # describe 'GET to /:slug'

    describe 'POST to /shorten' do
      shared_examples_for 'link_creator' do |expected_slug|
        before do
          allow(SlugNumber).to receive(:latest) { 80 }
        end

        it 'adds a link to storage' do
          expect { post '/shorten', params }
            .to change { Link.count }.by(1)
        end

        it 'returns a json with slug' do
          post '/shorten', params
          expect(last_response.status).to eq(200)
          expect(JSON.parse(last_response.body)['slug']).to eq expected_slug
        end
      end # shared_examples_for 'link_creator'

      context 'auto generated slug' do
        let(:params) { {url: 'https://www.youtube.com'} }

        it_behaves_like 'link_creator', 'BA'
      end

      context 'custom slugs' do
        let(:params) { {url: 'https://www.youtube.com', custom_slug: 'party'} }

        it_behaves_like 'link_creator', 'party'
      end
    end # describe 'POST to /shorten'
  end # describe App
end # module UrlShortener
