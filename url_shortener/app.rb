# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'sinatra/config_file'

require 'sinatra/param'

require './url_shortener/models/link'

require './url_shortener/actions/shorten'
require './url_shortener/actions/get'

module UrlShortener
  class App < Sinatra::Base
    helpers Sinatra::Param

    configure do
      enable :logging
    end

    get '/:slug' do
      param :slug, String, required: true
      result = Actions::Get.new(params['slug']).call
      if result
        redirect result.url, 301
      else
        halt 404
      end
    end

    post '/shorten' do
      param :url, String, required: true
      param :slug, String
      link = Actions::Shorten.new(params['url'], params['slug']).call
      if link
        json slug: link.returnable_slug
      else
        halt 422, json('Redirect not created, custom_slug taken')
      end
    end
  end # class App
end # module UrlShortener
