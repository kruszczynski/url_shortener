require './url-shortener/storage/link'

module UrlShortener
  module Storage
    class Basic
      @@data = []

      def self.save(url)
        slug = data.size.to_s
        link = Link.new(slug, url)
        data << link
        link
      end

      def self.data
        @@data
      end

      def self.find(slug)
        data.find { |link| link.slug == slug }
      end
    end # class Basic
  end # module Storage
end # module UrlShortener
