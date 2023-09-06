# frozen_string_literal: true

module StarlingApi
  module Accounts
    extend BaseApi

    class << self
      def fetch 
        account['accounts']
      end

      private

      def account
        BaseApi.api_call(:get, 'https://api-sandbox.starlingbank.com/api/v2/accounts')
      end
    end
  end
end
