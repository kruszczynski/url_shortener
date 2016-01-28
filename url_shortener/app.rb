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

    # register Sinatra::ConfigFile

    # config_file 'path/to/config.yml'

    enable :logging

    post '/shorten' do
      param :url, String, required: true
      param :custom_slug, String
      link = Actions::Shorten.call(params['url'], params['custom_slug'])
      if link
        json slug: link.returnable_slug
      else
        halt 422, json('Redirect not created, custom_slug taken')
      end
    end

    get '/:slug' do
      param :slug, String, required: true
      result = Actions::Get.call(params['slug'])
      if result
        redirect result.url, 301
      else
        halt 404
      end
    end
  end # class App
end # module UrlShortener
