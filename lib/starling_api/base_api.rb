# frozen_string_literal: true

module StarlingApi
  module BaseApi
    class << self
      def api_call(method, url, query: {}, body: {})
        response = HTTParty.send(method, url, headers:, query:, body:)
        
        return parse_response(response.body) if response.success?

        raise "#{response.code}: #{response_errors(parse_response(response))}"
      end

      def parse_response(response)
        JSON.parse(response)
      end

      private

      def response_errors(response)
        response['error_description'] || response['errors'].map { |error| error['message'] } 
      end

      def headers
        {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{Rails.configuration.access_token}",
          'Content-Type' => 'application/json'
        }
      end
    end
  end
end
