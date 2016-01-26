require './url-shortener/storage/link'

module UrlShortener
  module Storage
    class Basic
      @@data = []

      def self.save(url, custom_slug = nil)
        slug = data.size.to_s
        link = Link.new(slug, url, custom_slug)
        data << link
        link
      end

      def self.data
        @@data
      end

      def self.find(slug)
        data.find { |link| link.slug == slug || link.custom_slug == slug }
      end
    end # class Basic
  end # module Storage
end # module UrlShortener
