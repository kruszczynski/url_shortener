require 'sinatra'
require 'sinatra/json'
require 'sinatra/param'

require './url-shortener/storage/basic'

module UrlShortener
  class App < Sinatra::Base
    helpers Sinatra::Param

    enable :logging

    post '/shorten' do
      param :url, String, required: true
      link = Storage::Basic.save(params['url'])
      json slug: link.slug
    end

    # # debugging index page
    # get '/all' do
    #   json Storage::Basic.data
    # end

    get '/:slug' do
      param :slug, String, required: true
      result = Storage::Basic.find(params['slug'])
      if result
        redirect result.url, 301
      else
        halt 404
      end
    end
  end # class App
end # module UrlShortener
