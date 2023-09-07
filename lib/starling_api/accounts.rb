# frozen_string_literal: true

module StarlingApi
  module Accounts
    extend BaseApi

    class << self
      def fetch
        accounts['accounts']
      end

      private

      def accounts
        BaseApi.api_call(:get, 'https://api-sandbox.starlingbank.com/api/v2/accounts')
      end
    end
  end
end
