module Spyke::Kaminari
  class HeaderParser < Faraday::Response::Middleware
    def on_complete(env)
      @env = env

      metadata = Spyke::Kaminari::HEADERS.each_with_object({}) do |(symbol, key), hash|
        hash[symbol] = header(key)
      end

      @env.body[:metadata] ||= {}
      @env.body[:metadata][Spyke::Kaminari::METADATA_KEY] = metadata
    end

    private

    def header(key)
      value = @env.response_headers[key]
      value.try(:to_i)
    end
  end
end
