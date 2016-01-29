require 'bundler'
Bundler.setup

require './url_shortener/app'

UrlShortener::SlugNumber.instance.start
run UrlShortener::App
