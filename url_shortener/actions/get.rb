# frozen_string_literal: true

require './url_shortener/models/link'

module UrlShortener
  module Actions
    class Get
      def initialize(slug)
        @slug = slug
      end

      def call
        Link.find_by_both_slugs(@slug)
      end
    end # class Shorten
  end # module Actions
end # module UrlShortener
