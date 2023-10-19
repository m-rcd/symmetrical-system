# frozen_string_literal: true

class TransferToSavingGoal
  def initialize(account_uid:, amount:)
    @account_uid = account_uid
    @amount = amount
  end

  class << self
    def call(account_uid:, amount:)
      new(account_uid:, amount:).call
    end
  end

  def call
    create_saving_goal.tap { |saving_goal| transfer_to_saving_goal(saving_goal['savingsGoalUid']) }
  end

  private

  attr_reader :account_uid, :amount

  def create_saving_goal
    BankApi::SavingGoal.create(account_uid)
  end

  def transfer_to_saving_goal(saving_goal_uid)
    BankApi::SavingGoal.transfer_money(account_uid, saving_goal_uid, amount)
  end
end
