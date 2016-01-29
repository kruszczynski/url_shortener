# frozen_string_literal: true

require 'couchrest_model'

module UrlShortener
  # Link is model-like representation of database documents
  # that contain all data necessary to execute the redirect

  class Link < CouchRest::Model::Base
    property :url, String
    property :slug_number, Integer
    property :slug, String
    property :custom_slug, String

    validates_uniqueness_of :slug
    validates_uniqueness_of :slug_number
    validates_uniqueness_of :custom_slug

    timestamps!

    design do
      view :by_slug
      view :by_custom_slug
    end

    def self.find_by_both_slugs(slug)
      find_by_slug(slug) || find_by_custom_slug(slug)
    end

    def returnable_slug
      custom_slug || slug
    end
  end
end # module UrlShortener
