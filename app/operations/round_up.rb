# frozen_string_literal: true

class RoundUp
  MIN_DATE = DateTime.new(2023, 9, 0o3).beginning_of_week
  MAX_DATE = DateTime.now.end_of_week
  private_constant :MIN_DATE, :MAX_DATE

  def initialize(account_uid:, category_uid:, min_date: MIN_DATE, max_date: MAX_DATE)
    @account_uid = account_uid
    @category_uid = category_uid
    @min_date = min_date
    @max_date = max_date
    @round_up = 0
  end

  def call
    transactions.each do |transaction|
      amount = transaction['amount']['minorUnits']
      @round_up += (amount / 100.0).ceil * 100 - amount
    end
    round_up
  end

  private

  attr_accessor :account_uid, :category_uid, :min_date, :max_date, :round_up

  def transactions
    StarlingApi::Transactions.fetch(account_uid:, category_uid:, min_date:, max_date:).select do |feed_item|
      feed_item['direction'] == 'OUT'
    end
  end

  def transfer_to_saving_goal
    TransferToSavingGoal.call(account_uid: account['accountUid'], amount: round_up)
  end
end