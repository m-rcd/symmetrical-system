# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoundUpsController, type: :controller do
  describe 'GET /round_up' do
    let(:expected_response) do
      { 'round_up_amount' => '100 pence (£1.00)' }.to_json
    end

    before do
      expect(StarlingApi::Accounts).to receive(:fetch).and_return([{ 'accountUid' => 'abc',
                                                                    'defaultCategory' => 'cde' }])
    end
    context 'when transactions exist' do
      before do
        min_date = '02/09/2023'.to_datetime
        expect(RoundUp).to receive(:call).with(
          account_uid: 'abc', category_uid: 'cde', min_date:, max_date: min_date + 6
        ).and_return(100)
      end

      it 'returns http success' do
        get :round_up
        expect(response).to have_http_status(:success)
        expect(response.body).to eq(expected_response)
      end
    end

    context 'when no transactions exist' do
      let(:expected_response) do
        { 'error' => 'No transactions for that period' }.to_json
      end
      before do
        min_date = '02/09/2023'.to_datetime
        expect(RoundUp).to receive(:call).with(
          account_uid: 'abc', category_uid: 'cde', min_date:, max_date: min_date + 6
        ).and_raise(RuntimeError.new('No transactions for that period'))
      end

      it 'returns http an error' do
        get :round_up
        expect(response.body).to eq(expected_response)
      end
    end
  end

  describe 'POST /transfer' do
    let(:expected_response) do
      { 'round_up_amount' => '100 pence (£1.00)', 'transfer_uid' => 'qwerty' }.to_json
    end
    before do
      expect(StarlingApi::Accounts).to receive(:fetch).and_return([{ 'accountUid' => 'abc',
                                                                    'defaultCategory' => 'cde' }])
      min_date = '02/09/2023'.to_datetime
      expect(RoundUp).to receive(:call).with(
        account_uid: 'abc', category_uid: 'cde', min_date:, max_date: min_date + 6
      ).and_return(100)
      expect(TransferToSavingGoal).to receive(:call).with(account_uid: 'abc', amount: 100).and_return(
        { 'transferUid' => 'qwerty' }
      )
    end

    it 'returns http success' do
      post :transfer
      expect(response).to have_http_status(:success)
      expect(response.body).to eq(expected_response)
    end
  end
end
