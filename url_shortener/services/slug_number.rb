# frozen_string_literal: true

module UrlShortener
  class SlugNumber
    def self.latest
      rand(2**16)
    end
  end # class SlugNumber
end # module UrlShortener
