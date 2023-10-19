# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BankApi::Transactions do
  subject { described_class.fetch(account_uid:, category_uid:, min_date:, max_date:) }

  let(:account_uid) { 'be7290c6-88bb-49c4-9615-ec94b28e1c4fs' }
  let(:category_uid) { 'be7279f7-ddda-4faa-8c33-e60c14922b06' }
  let(:min_date) { DateTime.new(2023, 9, 0o3).beginning_of_week }
  let(:max_date) { DateTime.now.end_of_week }

  let(:headers) do
    {
      'Accept' => 'application/json',
      'Authorization' => authorization,
      'Content-Type' => 'application/json'
    }.compact
  end

  let(:query) do
    {
      minTransactionTimestamp: min_date,
      maxTransactionTimestamp: max_date
    }
  end

  context 'when token is provided' do
    let(:authorization) { "Bearer #{Rails.configuration.access_token}" }

    let(:body) do
      {
        'feedItems' => [
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
            'batchPaymentDetails' => nil },
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
        ]
      }
    end

    let(:expected_transactions) do
      [
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
          'batchPaymentDetails' => nil },
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
      ]
    end

    before do
      stub_request(:get, "#{Rails.configuration.bank_api_url}/feed/account/#{account_uid}/category/#{category_uid}/transactions-between").with(
        headers:,
        query:
      ).to_return(
        body: body.to_json,
        status: 200
      )
    end

    it 'returns the transactions' do
      expect(subject).to match(expected_transactions)
      subject
    end
  end

  context 'when token is not provided' do
    let(:body) do
      {
        'error': 'invalid_token',
        'error_description': 'No access token provided in request. `Header: Authorization` must be set '
      }
    end
    let(:authorization) { 'Bearer' }

    before do
      stub_request(:get, "#{Rails.configuration.bank_api_url}/feed/account/#{account_uid}/category/#{category_uid}/transactions-between").with(
        headers:,
        query:
      ).to_return(
        body: body.to_json,
        status: 403
      )

      allow(Rails.configuration).to receive(:access_token).and_return('')
    end

    it 'raises an error' do
      expect do
        subject
      end.to raise_error(RuntimeError, /403: No access token provided in request. `Header: Authorization` must be set/)
    end
  end
end
