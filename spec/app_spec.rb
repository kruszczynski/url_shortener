# frozen_string_literal: true

require 'spec_helper'

require './url_shortener/app'

module UrlShortener
  describe App do
    include Rack::Test::Methods

    def app
      App
    end

    describe 'GET to /:slug' do
      before do
        test_data.each { |link_params| Link.new(link_params).save }
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

      context 'auto generated slugs' do
        let(:test_data) do
          [
            {url: 'https://www.google.com', slug_number: 80, slug: 'BA'},
            {url: 'https://www.facebook.com', slug_number: 81, slug: 'BB'},
            {url: 'https://www.twitter.com', slug_number: 159, slug: 'B='},
            {url: 'https://www.shopify.com', slug_number: 161, slug: 'CB'},
            {url: 'https://www.github.com', slug_number: 6399, slug: '=='},
          ]
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
        let(:test_data) do
          [
            {url: 'https://bit.ly', slug_number: 80,
             slug: 'BA', custom_slug: 'bitly'},
            {url: 'https://goo.gl', slug_number: 81,
             slug: 'BB', custom_slug: 'googl'},
            {url: 'https://www.twitter.com', slug_number: 159,
             slug: 'B=', custom_slug: 'twitter_fitter'},
            {url: 'https://www.shopify.com', slug_number: 161,
             slug: 'CB', custom_slug: 'buy_stuff_here'},
            {url: 'https://www.github.com', slug_number: 6399,
             slug: '==', custom_slug: 'code_code_code'},
          ]
        end

        it_behaves_like 'redirects', 'bitly', 'https://bit.ly'
        it_behaves_like 'redirects', 'googl', 'https://goo.gl'
        it_behaves_like 'redirects', 'twitter_fitter', 'https://www.twitter.com'
        it_behaves_like 'redirects', 'buy_stuff_here', 'https://www.shopify.com'
        it_behaves_like 'redirects', 'code_code_code', 'https://www.github.com'
      end # context 'custom slugs'
    end # describe 'GET to /:slug'

    describe 'POST to /shorten' do
      shared_examples_for 'link_creator' do |expected_slug|
        before do
          allow(SlugNumber.instance).to receive(:latest) { 80 }
        end

        it 'adds a link to storage' do
          expect { shorten_request }.to change { Link.count }.by(1)
        end

        it 'is a successful response' do
          shorten_request
          expect(last_response.status).to eq(200)
        end

        context 'json response' do
          let(:parsed_json) { JSON.parse(last_response.body) }
          before { shorten_request }

          it 'returns redirect target' do
            expect(parsed_json['target']).to eq(params[:url])
          end

          it 'returns shortened link' do
            expect(parsed_json['url']).to eq(
              "http://test.host/#{expected_slug}")
          end
        end

        def shorten_request
          post '/shorten', params
        end
      end # shared_examples_for 'link_creator'

      context 'auto generated slug' do
        let(:params) { {url: 'https://www.youtube.com'} }

        it_behaves_like 'link_creator', 'BA'
      end

      context 'custom slugs' do
        let(:url) { 'https://www.youtube.com' }
        let(:custom_slug) { 'party' }
        let(:params) { {url: url, slug: custom_slug} }

        it_behaves_like 'link_creator', 'party'

        shared_examples_for 'error_response' do |error_message|
          it 'does not create a link' do
            expect { post '/shorten', params }
              .to_not change { Link.count }
          end

          it 'returns status 422' do
            post '/shorten', params
            expect(last_response.status).to eq(422)
          end

          it 'returns error message' do
            post '/shorten', params
            expect(JSON.parse(last_response.body)['error'])
              .to eq(error_message)
          end
        end

        context 'with slug taken' do
          before do
            Actions::Shorten.new(url, custom_slug).call
          end

          it_behaves_like 'error_response',
                          'Redirect not created, slug party taken'
        end

        context 'with invalid url' do
          let(:url) { 'www.youtube.com' }

          it_behaves_like 'error_response', 'Redirect not created, url has to '\
                                            'start with http or https'
        end
      end
    end # describe 'POST to /shorten'
  end # describe App
end # module UrlShortener
