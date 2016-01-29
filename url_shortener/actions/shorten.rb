# frozen_string_literal: true

require './url_shortener/models/link'
require './url_shortener/services/slug_generator'
require './url_shortener/services/slug_number'

module UrlShortener
  module Actions
    # Shorten is a controller-like abstraction of all steps
    # necessary to create a Link based on request's parameters

    class Shorten
      attr_reader :message

      def initialize(url, custom_slug = nil)
        @url = url
        @custom_slug = custom_slug
      end

      # this method smells of :reek:TooManyStatements
      def call
        return false unless slug_available?
        return false if url_invalid?
        generate_valid_slug_number
        link = Link.new(url: @url,
                        custom_slug: @custom_slug,
                        slug: generate_slug,
                        slug_number: @slug_number)
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

      # This seems weird and it is. However it might happen that custom slug
      # will intrude generated slugs domain. In such case we don't want our
      # service to be disrupted, we want to regenerate auto slug
      #
      # this method smells of :reek:DuplicateMethodCall
      def generate_valid_slug_number
        retries_count = 0
        @slug_number = SlugNumber.instance.latest
        while Link.find_by_both_slugs(generate_slug)
          @slug_number = SlugNumber.instance.latest
          retries_count += 1

          # Break to prevent infinite look in case something goes very wrong.
          # Because slug_number will be taken, Link's uniqueness validation
          # will not allow for bad data to be created.
          #
          break if retries_count > 10
        end
      end

      def generate_slug
        SlugGenerator.generate(@slug_number)
      end
    end # class Shorten
  end # module Actions
end # module UrlShortener
