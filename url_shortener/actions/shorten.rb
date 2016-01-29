# frozen_string_literal: true

require './url_shortener/models/link'
require './url_shortener/services/slug_generator'
require './url_shortener/services/slug_number'

module UrlShortener
  module Actions
    class Shorten
      def initialize(url, custom_slug = nil)
        @url = url
        @custom_slug = custom_slug
      end

      def call
        return false unless slug_available?
        slug_number = SlugNumber.instance.latest
        link = Link.new(url: @url,
                        custom_slug: @custom_slug,
                        slug: SlugGenerator.generate(slug_number),
                        slug_number: slug_number)
        link.save
        link.persisted? && link
      end

      def slug_available?
        !Link.find_by_both_slugs(@custom_slug)
      end
    end # class Shorten
  end # module Actions
end # module UrlShortener
