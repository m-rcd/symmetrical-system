# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoundUp do
  subject { described_class.new(account_uid:, category_uid:, min_date:, max_date:).call }

  let(:account_uid)  { 'dg7394c6-88bb-49c4-9615-ec94b28e1cafs' }
  let(:category_uid) { 'abc279f7-ddda-4faa-8c33-e60c14922b06' }
  let(:min_date) { DateTime.new(2023, 9, 0o3).beginning_of_week }
  let(:max_date) { min_date + 6 }

  let(:out_transaction_1) do
    { 'feedItemUid' => 'c41bc370-81b9-4a55-af2c-282b75b1d2bd',
      'categoryUid' => 'be7279f7-ddda-4faa-8c33-e60c14922b06',
      'amount' => { 'currency' => 'GBP', 'minorUnits' => 500 },
      'sourceAmount' => { 'currency' => 'GBP', 'minorUnits' => 500 },
      'direction' => 'OUT',
      'updatedAt' => '2023-09-04T15:23:04.733Z',
      'transactionTime' => '2023-09-04T15:23:04.578Z',
      'settlementTime' => '2023-09-04T15:23:04.578Z',
      'source' => 'INTERNAL_TRANSFER',
      'status' => 'SETTLED',
      'transactingApplicationUserUid' => 'be71af23-8135-404f-acae-2bd8e30e40b3',
      'counterPartyType' => 'CATEGORY',
      'counterPartyUid' => '96f95a9e-e60c-41eb-bbcf-0609e63937e7',
      'counterPartyName' => 'Trip to the arctic',
      'country' => 'GB',
      'spendingCategory' => 'SAVING',
      'hasAttachment' => false,
      'hasReceipt' => false,
      'batchPaymentDetails' => nil }
  end

  let(:out_transaction_2) do
    { 'feedItemUid' => 'c409bf47-5229-4223-90ec-106eada69023',
      'categoryUid' => 'be7279f7-ddda-4faa-8c33-e60c14922b06',
      'amount' => { 'currency' => 'GBP', 'minorUnits' => 448 },
      'sourceAmount' => { 'currency' => 'GBP', 'minorUnits' => 448 },
      'direction' => 'OUT',
      'updatedAt' => '2023-09-04T15:05:42.450Z',
      'transactionTime' => '2023-09-04T15:05:42.337Z',
      'settlementTime' => '2023-09-04T15:05:42.337Z',
      'source' => 'INTERNAL_TRANSFER',
      'status' => 'SETTLED',
      'transactingApplicationUserUid' => 'be71af23-8135-404f-acae-2bd8e30e40b3',
      'counterPartyType' => 'CATEGORY',
      'counterPartyUid' => '7c2ed278-4cb3-4792-8e16-8107a5733dc4',
      'counterPartyName' => 'Trip to the arctic',
      'country' => 'GB',
      'spendingCategory' => 'SAVING',
      'hasAttachment' => false,
      'hasReceipt' => false,
      'batchPaymentDetails' => nil }
  end

  let(:out_transaction_3) do
    { 'feedItemUid' => 'c3fa1281-5624-4519-b613-27af1856f073',
      'categoryUid' => 'be7279f7-ddda-4faa-8c33-e60c14922b06',
      'amount' => { 'currency' => 'GBP', 'minorUnits' => 544 },
      'sourceAmount' => { 'currency' => 'GBP', 'minorUnits' => 544 },
      'direction' => 'OUT',
      'updatedAt' => '2023-09-04T14:50:23.450Z',
      'transactionTime' => '2023-09-04T14:50:23.367Z',
      'settlementTime' => '2023-09-04T14:50:23.367Z',
      'source' => 'INTERNAL_TRANSFER',
      'status' => 'SETTLED',
      'transactingApplicationUserUid' => 'be71af23-8135-404f-acae-2bd8e30e40b3',
      'counterPartyType' => 'CATEGORY',
      'counterPartyUid' => '0bc19983-4ef0-4d19-b23f-a16d0aa4d068',
      'counterPartyName' => 'Trip to the arctic',
      'country' => 'GB',
      'spendingCategory' => 'SAVING',
      'hasAttachment' => false,
      'hasReceipt' => false,
      'batchPaymentDetails' => nil }
  end

  let(:out_transaction_4) do
    { 'feedItemUid' => 'c348437f-3c9c-46ce-be27-4364641588a4',
      'categoryUid' => 'be7279f7-ddda-4faa-8c33-e60c14922b06',
      'amount' => { 'currency' => 'GBP', 'minorUnits' => 1269 },
      'sourceAmount' => { 'currency' => 'GBP', 'minorUnits' => 1269 },
      'direction' => 'OUT',
      'updatedAt' => '2023-09-04T11:52:58.136Z',
      'transactionTime' => '2023-09-04T11:52:58.063Z',
      'settlementTime' => '2023-09-04T11:52:58.063Z',
      'source' => 'INTERNAL_TRANSFER',
      'status' => 'SETTLED',
      'transactingApplicationUserUid' => 'be71af23-8135-404f-acae-2bd8e30e40b3',
      'counterPartyType' => 'CATEGORY',
      'counterPartyUid' => '523dd6cd-390f-4cea-8ced-cf6ff09812ee',
      'counterPartyName' => 'Trip to the arctic',
      'country' => 'GB',
      'spendingCategory' => 'SAVING',
      'hasAttachment' => false,
      'hasReceipt' => false,
      'batchPaymentDetails' => nil }
  end

  let(:in_transaction_1) do
    { 'feedItemUid' => 'be753263-2a56-46ee-87e1-2a14fb7cee81',
      'categoryUid' => 'be7279f7-ddda-4faa-8c33-e60c14922b06',
      'amount' => { 'currency' => 'GBP', 'minorUnits' => 50_000 },
      'sourceAmount' => { 'currency' => 'GBP', 'minorUnits' => 50_000 },
      'direction' => 'IN',
      'updatedAt' => '2023-09-03T15:17:00.266Z',
      'transactionTime' => '2023-09-03T15:17:00.000Z',
      'settlementTime' => '2023-09-03T15:17:00.000Z',
      'source' => 'FASTER_PAYMENTS_IN',
      'status' => 'SETTLED',
      'counterPartyType' => 'SENDER',
      'counterPartyName' => 'Faster payment',
      'counterPartySubEntityName' => '',
      'counterPartySubEntityIdentifier' => '600522',
      'counterPartySubEntitySubIdentifier' => '20025076',
      'reference' => 'Ref: 5707843855',
      'country' => 'GB',
      'spendingCategory' => 'INCOME',
      'hasAttachment' => false,
      'hasReceipt' => false,
      'batchPaymentDetails' => nil }
  end

  let(:in_transaction_2) do
    { 'feedItemUid' => 'be75fa53-e365-4a3f-ab07-01b93c874083',
      'categoryUid' => 'be7279f7-ddda-4faa-8c33-e60c14922b06',
      'amount' => { 'currency' => 'GBP', 'minorUnits' => 667 },
      'sourceAmount' => { 'currency' => 'GBP', 'minorUnits' => 667 },
      'direction' => 'IN',
      'updatedAt' => '2023-09-03T15:17:00.861Z',
      'transactionTime' => '2023-09-03T15:17:00.000Z',
      'settlementTime' => '2023-09-03T15:17:00.000Z',
      'source' => 'FASTER_PAYMENTS_IN',
      'status' => 'SETTLED',
      'counterPartyType' => 'SENDER',
      'counterPartyName' => 'Faster payment',
      'counterPartySubEntityName' => '',
      'counterPartySubEntityIdentifier' => '600522',
      'counterPartySubEntitySubIdentifier' => '20025157',
      'reference' => 'Ref: 6144822475',
      'country' => 'GB',
      'spendingCategory' => 'INCOME',
      'hasAttachment' => false,
      'hasReceipt' => false,
      'batchPaymentDetails' => nil }
  end

  before do
    expect(BankApi::Transactions).to receive(:fetch).with(
      account_uid:, category_uid:, min_date:, max_date:
    ).and_return(transactions_query_response)
  end

  context 'when transactions for that period exist' do
    let(:transactions_query_response) do
      [out_transaction_1, out_transaction_2, out_transaction_3, out_transaction_4, in_transaction_1, in_transaction_2]
    end

    it 'rounds up the amount from out transactions only' do
      expect(subject).to eq(139)
    end
  end

  context 'when transactions for that period do not exist' do
    let(:transactions_query_response) { [] }

    it 'raises an error' do
      expect { subject }.to raise_error(RuntimeError, 'No transactions for that period')
    end
  end
end
