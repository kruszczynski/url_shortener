require './url-shortener/storage/basic'

module UrlShortener
  module Actions
    class Shorten
      def self.call(url, custom_slug = nil)
        link = Storage::Basic.save(url, custom_slug)
        link.custom_slug || link.slug
      end
    end # class Shorten
  end # module Actions
end # module UrlShortener
