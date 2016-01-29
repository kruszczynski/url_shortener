# frozen_string_literal: true

require './url_shortener/models/link'
require './url_shortener/services/slug_generator'
require './url_shortener/services/slug_number'

module UrlShortener
  module Actions
    class Shorten
      attr_reader :message

      def initialize(url, custom_slug = nil)
        @url = url
        @custom_slug = custom_slug
      end

      def call
        return false unless slug_available?
        return false if url_invalid?
        slug_number = SlugNumber.instance.latest
        link = Link.new(url: @url,
                        custom_slug: @custom_slug,
                        slug: SlugGenerator.generate(slug_number),
                        slug_number: slug_number)
        link.save
        link.persisted? && link
      end

      def slug_available?
        available = !Link.find_by_both_slugs(@custom_slug)
        @message = slug_taken_message unless available
        available
      end

      def url_invalid?
        invalid = !(@url =~ %r{^(http:\/\/|https:\/\/)})
        if invalid
          @message = 'Redirect not created, url has to start with http or https'
        end
        invalid
      end

      private

      def slug_taken_message
        "Redirect not created, slug #{@custom_slug} taken"
      end
    end # class Shorten
  end # module Actions
end # module UrlShortener
