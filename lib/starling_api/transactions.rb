# frozen_string_literal: true

module StarlingApi
  module Transactions
    extend BaseApi

    class << self
      def fetch(account_uid:, category_uid:, min_date:, max_date:)
        transactions(account_uid, category_uid, min_date, max_date)['feedItems']
      end

      private

      def transactions(account_uid, category_uid, min_date, max_date)
        BaseApi.api_call(:get, url(account_uid, category_uid),
                         query: query(min_date, max_date))
      end

      def url(account_uid, category_uid)
        "https://api-sandbox.starlingbank.com/api/v2/feed/account/#{account_uid}/category/#{category_uid}/transactions-between"
      end

      def query(min_date, max_date)
        {
          minTransactionTimestamp: min_date,
          maxTransactionTimestamp: max_date
        }
      end
    end
  end
end
