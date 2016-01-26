require 'spec_helper'
require './url-shortener/app'

RSpec.describe UrlShortener::App do
  include Rack::Test::Methods
  def app
    UrlShortener::App
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
        UrlShortener::Storage::Basic.save('https://www.google.com')
        UrlShortener::Storage::Basic.save('https://www.facebook.com')
        UrlShortener::Storage::Basic.save('http://www.kruszczynski.net')
        UrlShortener::Storage::Basic.save('https://www.shopify.com')
        UrlShortener::Storage::Basic.save('https://www.github.com')
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
    end # context 'auto generated slugs'

    context 'custom slugs' do
    end
  end # describe 'GET to /:slug'

  describe 'POST to /shorten' do
    shared_examples_for 'link creator' do |expected_slug|
      it 'adds a link to storage' do
        expect { post '/shorten', params }
          .to change(UrlShortener::Storage::Basic.data, :size).by(1)
      end

      it 'returns a json with slug' do
        post '/shorten', params
        expect(last_response.status).to eq(200)
        expect(JSON.parse(last_response.body)['slug']).to eq expected_slug
      end
    end # shared_examples_for 'link_creator'

    context 'auto generated slug' do
      let(:params) { {url: 'https://www.youtube.com'} }

      it_behaves_like 'link creator', '0'
    end

    context 'custom slugs' do
      let(:params) { {url: 'https://www.youtube.com', custom_slug: 'party'} }

      it_behaves_like 'link creator', 'party'
    end
  end # describe 'POST to /shorten'
end
