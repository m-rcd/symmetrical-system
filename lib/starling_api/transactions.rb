# frozen_string_literal: true

module StarlingApi
  module Transactions
    extend BaseApi

    class << self
      MIN_DATE = DateTime.new(2023, 9, 0o3).beginning_of_week
      MAX_DATE = DateTime.now.end_of_week
      private_constant :MIN_DATE, :MAX_DATE

      def fetch(account_uid:, category_uid:, min_date: MIN_DATE, max_date: MAX_DATE)
        transactions(account_uid, category_uid, min_date, max_date)['feedItems']
      end

      private

      def transactions(account_uid, category_uid, min_date, max_date)
        BaseApi.api_call(:get, transactions_url(account_uid, category_uid),
                         query: transactions_query(min_date, max_date))
      end

      def transactions_url(account_uid, category_uid)
        "https://api-sandbox.starlingbank.com/api/v2/feed/account/#{account_uid}/category/#{category_uid}/transactions-between"
      end

      def transactions_query(min_date, max_date)
        {
          minTransactionTimestamp: min_date,
          maxTransactionTimestamp: max_date
        }
      end
    end
  end
end
