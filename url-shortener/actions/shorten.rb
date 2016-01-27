require './url-shortener/models/link'

module UrlShortener
  module Actions
    class Shorten
      def self.call(url, custom_slug = nil)
        link = Link.new(url: url, custom_slug: custom_slug)
        link.save
        link.custom_slug || link.slug
      end
    end # class Shorten
  end # module Actions
end # module UrlShortener
