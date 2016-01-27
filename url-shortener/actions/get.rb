require './url-shortener/models/link'

module UrlShortener
  module Actions
    class Get
      def self.call(slug)
        Link.by_slug(keys: [slug]).first
      end
    end # class Shorten
  end # module Actions
end # module UrlShortener
