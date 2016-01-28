require 'couchrest_model'

module UrlShortener
  class Link < CouchRest::Model::Base
    property :url, String
    property :slug_number, Integer
    property :slug, String
    property :custom_slug, String

    # validates_uniqueness_of :slug
    # validates_uniqueness_of :slug_number
    # validates_uniqueness_of :custom_slug
    # validates_uniqueness_of :url

    timestamps!

    design do
      view :by_slug
      view :by_custom_slug
    end

    def returnable_slug
      custom_slug || slug
    end
  end
end # module UrlShortener
