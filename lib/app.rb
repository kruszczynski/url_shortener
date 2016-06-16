# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'sinatra/config_file'

require 'sinatra/param'

require './lib/models/link'

require './lib/actions/shorten'
require './lib/actions/get'

module UrlShortener
  class App < Sinatra::Base
    helpers Sinatra::Param

    configure do
      enable :logging

      set :log_output, ::File.new("./log/#{environment}.log", 'a+')
    end

    # GET /:slug
    #
    # The redirecting part of url shortening. :slug has to exist in database
    get '/:slug' do
      param :slug, String, required: true
      result_link = Actions::Get.new(params['slug']).call
      if result_link
        redirect result_link.url, 301
      else
        halt 404
      end
    end

    # POST  /shorten?url=http://example.com
    # POST  /shorten?url=http://example.com&slug=example
    #
    # Shortened link creation endpoint
    post '/shorten' do
      param :url, String, required: true
      param :slug, String
      action = Actions::Shorten.new(params['url'], params['slug'])
      link = action.call
      if link
        json url: "#{ENV['ROOT_URL']}/#{link.returnable_slug}",
             target: params['url']
      else
        halt 422, json(error: action.message)
      end
    end
  end # class App
end # module UrlShortener
