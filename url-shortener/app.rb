require 'sinatra'

module UrlShortener
  class App < Sinatra::Base
    post '/shorten' do
      'shortening'
    end

    # get '/s/:slug'

    # get '/c/:custom_slug'
  end # class App
end # module UrlShortener
