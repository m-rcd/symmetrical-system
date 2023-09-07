# frozen_string_literal: true

class RoundUp
  class << self
    def call(account_uid:, category_uid:, min_date:, max_date:)
      new(account_uid:, category_uid:, min_date:, max_date:).call
    end
  end

  def initialize(account_uid:, category_uid:, min_date:, max_date:)
    @account_uid = account_uid
    @category_uid = category_uid
    @min_date = min_date
    @max_date = max_date
    @round_up_amount = 0
  end

  def call
    raise 'No transactions for that period' if transactions.empty?

    calculate_round_up
    round_up_amount
  end

  private

  attr_accessor :account_uid, :category_uid, :min_date, :max_date, :round_up_amount

  def calculate_round_up
    transactions.each do |transaction|
      amount = transaction['amount']['minorUnits']
      @round_up_amount += (amount / 100.0).ceil * 100 - amount
    end
  end

  def transactions
    @transactions ||= StarlingApi::Transactions.fetch(account_uid:, category_uid:, min_date:,
                                                      max_date:).select do |feed_item|
      feed_item['direction'] == 'OUT'
    end
  end
end
