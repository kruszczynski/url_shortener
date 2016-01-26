module UrlShortener
  module Storage
    Link = Struct.new(:slug, :url, :custom_slug)
  end # module Storage
end # module UrlShortener
