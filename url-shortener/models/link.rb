require 'couchrest_model'

module UrlShortener
  class Link < CouchRest::Model::Base
    property :url, String
    property :slug, String
    property :custom_slug, String

    timestamps!

    design do
      view :by_slug
      view :by_custom_slug
    end

    # override CouchRest's initialize to automatically set slug
    def initialize(attributes = {}, options = {})
      attributes[:slug] = self.class.count
      super
    end
  end
end # module UrlShortener
