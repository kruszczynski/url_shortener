require 'spec_helper'
require  File.expand_path '../../url-shortener/app', __FILE__

RSpec.describe UrlShortener::App do
  include Rack::Test::Methods
  def app
    UrlShortener::App
  end

  describe "POST shorten" do
    it "returns shorten" do
      post "/shorten"

      expect(last_response.body).to eq("shortening")
      expect(last_response.status).to eq 200
    end
  end
end
