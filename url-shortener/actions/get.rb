require './url-shortener/storage/basic'

module UrlShortener
  module Actions
    class Get
      def self.call(slug)
        Storage::Basic.find(slug)
      end
    end # class Shorten
  end # module Actions
end # module UrlShortener
