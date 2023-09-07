# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransferToSavingGoal do
  subject { described_class.call(account_uid:, amount:) }

  let(:account_uid) { 'abc-123' }
  let(:amount) { 34 }
  let(:saving_goal) { { 'savingsGoalUid' => 'cde-456' } }

  before do
    expect(StarlingApi::SavingGoal).to receive(:create).with(account_uid).and_return(saving_goal)
  end

  it 'transfers the money to a new saving goal' do
    expect(StarlingApi::SavingGoal).to receive(:transfer_money).with(account_uid, saving_goal['savingsGoalUid'], amount)
    subject
  end
end
