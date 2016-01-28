require 'couchrest_model'

module UrlShortener
  class Link < CouchRest::Model::Base
    property :url, String
    property :slug_number, Integer
    property :slug, String
    property :custom_slug, String

    timestamps!

    design do
      view :by_slug
      view :by_custom_slug
    end
  end
end # module UrlShortener
