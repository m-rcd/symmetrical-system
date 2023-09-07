# frozen_string_literal: true

module StarlingApi
  module SavingGoal
    require 'securerandom'

    extend BaseApi

    class << self
      def fetch(account_uid, saving_goal_uid)
        BaseApi.api_call(:get, get_url(account_uid, saving_goal_uid))
      end

      def create(account_uid)
        BaseApi.api_call(:put, create_url(account_uid), body: create_body)
      end

      def transfer_money(account_uid, saving_goal_uid, amount)
        BaseApi.api_call(:put, add_money_url(account_uid, saving_goal_uid), body: add_money_body(amount))
      end

      private

      def create_url(account_uid)
        "https://api-sandbox.starlingbank.com/api/v2/account/#{account_uid}/savings-goals"
      end

      def create_body
        {
          'name': 'Trip to the arctic',
          'currency': 'GBP',
          'target': {
            'currency': 'GBP',
            'minorUnits': 0
          }
        }.to_json
      end

      def get_url(account_uid, saving_goal_uid)
        "https://api-sandbox.starlingbank.com/api/v2/account/#{account_uid}/savings-goals/#{saving_goal_uid}"
      end

      def add_money_url(account_uid, saving_goal_uid)
        "https://api-sandbox.starlingbank.com/api/v2/account/#{account_uid}/savings-goals/#{saving_goal_uid}/add-money/#{transfer_uid}"
      end

      def transfer_uid
        SecureRandom.uuid
      end

      def add_money_body(amount)
        {
          'amount': {
            'currency': 'GBP',
            'minorUnits': amount
          }
        }.to_json
      end
    end
  end
end
