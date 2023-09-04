# frozen_string_literal: true

class RoundUp 
    def initialize
      @round_up = 0 
    end

    def call 
      transactions.each do |transaction|
         amount = transaction["amount"]["minorUnits"]
         @round_up += (amount/100.0).ceil * 100 - amount
      end
      transfer_to_saving_goal
    end

    private 

    attr_accessor :round_up

    def transactions
      StarlingApi::Transactions.fetch(account["accountUid"], account["defaultCategory"]).select { |feed_item| feed_item["direction"] == "OUT" }
    end

    def account
      @account ||= StarlingApi::Account.fetch
    end

    def create_saving_goal
      @saving_goal ||= StarlingApi::SavingGoal.create(account["accountUid"])
    end

    def transfer_to_saving_goal
      TransferToSavingGoal.call(account_uid: account["accountUid"], amount: round_up)
    end
end