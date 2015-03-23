require 'json'

module TestClient
  class JSONParser < Faraday::Response::Middleware
    def parse(body)
      {data: JSON.parse(body)}
    end
  end

  module API
    def self.setup
      Faraday.new do |faraday|
        # Response middleware
        faraday.use Spyke::Kaminari::HeaderParser
        faraday.use JSONParser

        # Adapter middleware
        faraday.adapter(:test) do |stub|
          stub.get('/characters') { |env| TestService.new(env).characters }
        end
      end
    end
  end

  class Model < Spyke::Base
    include Spyke::Kaminari::Scopes

    self.connection = API.setup
    uri 'characters'
    scope :strong_badians, -> { where(strong_badian: true) }
  end
end
