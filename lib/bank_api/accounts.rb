# frozen_string_literal: true

module BankApi
  module Accounts
    extend BaseApi

    class << self
      def fetch
        accounts['accounts']
      end

      private

      def accounts
        BaseApi.api_call(:get, "#{BaseApi.api_url}/accounts")
      end
    end
  end
end
