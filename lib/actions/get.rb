# frozen_string_literal: true

require './lib/models/link'

module UrlShortener
  module Actions
    # Get is a controller-like abstraction of Link
    # retrieval from the DB in order to execute the redirect

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
