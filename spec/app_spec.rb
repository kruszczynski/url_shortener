require 'spec_helper'
require './url-shortener/app'

RSpec.describe UrlShortener::App do
  include Rack::Test::Methods
  def app
    UrlShortener::App
  end

  describe 'GET to /:slug' do
    context 'regular slugs' do
      before do
        UrlShortener::Storage::Basic.save('https://www.google.com')
        UrlShortener::Storage::Basic.save('https://www.facebook.com')
        UrlShortener::Storage::Basic.save('http://www.kruszczynski.net')
        UrlShortener::Storage::Basic.save('https://www.shopify.com')
        UrlShortener::Storage::Basic.save('https://www.github.com')
      end

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

      it_behaves_like 'redirects', '0', 'https://www.google.com'
      it_behaves_like 'redirects', '1', 'https://www.facebook.com'
      it_behaves_like 'redirects', '2', 'http://www.kruszczynski.net'
      it_behaves_like 'redirects', '3', 'https://www.shopify.com'
      it_behaves_like 'redirects', '4', 'https://www.github.com'

      it 'returns a 404 for not existing slug' do
        get '/fightforyourrighttoparty'
        expect(last_response.status).to eq(404)
      end
    end

    context 'custom slugs'
  end

  describe 'POST to /shorten' do
    it 'adds a link to storage' do
      expect { post '/shorten', url: 'https://www.youtube.com' }
        .to change(UrlShortener::Storage::Basic.data, :size).by(1)
    end

    it 'returns a json with slug' do
      post '/shorten', url: 'https://www.youtube.com'
      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)['slug']).to eq '0'
    end
  end
end
