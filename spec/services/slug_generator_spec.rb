require 'spec_helper'

require './url-shortener/services/slug_generator'

module UrlShortener
  describe SlugGenerator do
    context '.generate' do
      shared_examples_for 'generates_slug' do |number, expected|
        it "generates #{expected} from #{number}" do
          expect(SlugGenerator.generate(number)).to eq(expected)
        end
      end

      it_behaves_like 'generates_slug', 0, 'A'
      it_behaves_like 'generates_slug', 20, 'U'
      it_behaves_like 'generates_slug', 60, '8'
      it_behaves_like 'generates_slug', 70, '!'
      it_behaves_like 'generates_slug', 80, 'BA'
      it_behaves_like 'generates_slug', 81, 'BB'
      it_behaves_like 'generates_slug', 159, 'B='
      it_behaves_like 'generates_slug', 161, 'CB'
      it_behaves_like 'generates_slug', 6399, '=='
      it_behaves_like 'generates_slug', 6400, 'BAA'
    end
  end # describe SlugGenerator
end # module UrlShortener
