# frozen_string_literal: true

module UrlShortener
  # SlugGenerator uses 80 legal URL characters to generate
  # a slug from a number. It converts the number to base 80
  # and represents it using given characters

  class SlugGenerator
    # Yes, it's 10 chars per row
    URL_CHARACTERS = 'ABCDEFGHIJ'\
                     'KLMNOPQRST'\
                     'UVWXYZabcd'\
                     'efghijklmn'\
                     'opqrstuvwx'\
                     'yz01234567'\
                     '89-._~:[]@'\
                     "!$'()*+,;=".freeze

    def self.generate(number)
      base_80_array(number).map { |element| URL_CHARACTERS[element] }.join('')
    end

    # reek reports this method as unused (wrongly) and the warning
    # cannot be disabled by a comment. Likey a reek bug
    #
    # Converts base 10 number to array of numbers from 0 to 79
    def self.base_80_array(number)
      return [0] if number == 0
      [].tap do |array|
        base = URL_CHARACTERS.size
        while number > 0
          array.unshift(number % base)
          number /= base
        end
      end
    end

    private_class_method :base_80_array
  end # class SlugGenerator
end # module UrlShortener
