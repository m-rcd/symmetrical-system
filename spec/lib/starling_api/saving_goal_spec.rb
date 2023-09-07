# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'

RSpec.describe StarlingApi::SavingGoal do
  subject { described_class }

  let(:headers) do
    {
      'Accept' => 'application/json',
      'Authorization' => authorization,
      'Content-Type' => 'application/json'
    }.compact
  end
  let(:authorization) { "Bearer #{Rails.configuration.access_token}" }
  let(:account_uid) { 'abc-def-123-344' }

  describe '#create' do
    let(:request_body) do
      {
        'name': 'Trip to the arctic',
        'currency': 'GBP',
        'target': {
          'currency': 'GBP',
          'minorUnits': 0
        }
      }
    end

    let(:response_body) do
      { 'savingsGoalUid' => '44e3dedf-e800-4f04-8c13-3ddc8d4437fc', 'success' => true }
    end

    before do
      stub_request(:put, "https://api-sandbox.starlingbank.com/api/v2/account/#{account_uid}/savings-goals").with(
        headers:,
        body: request_body.to_json
      ).to_return(
        body: response_body.to_json,
        status: 200
      )
    end

    it 'creates a saving goal' do
      expect(subject.create(account_uid)).to match(response_body)
      subject
    end
  end

  describe '#fetch' do
    let(:response_body) do
      {
        'savingsGoalUid' => '44e3dedf-e800-4f04-8c13-3ddc8d4437fc',
        'name' => 'Trip to the arctic',
        'totalSaved' => {
          'currency' => 'GBP',
          'minorUnits' => 0
        },
        'state' => 'ACTIVE'
      }
    end

    let(:saving_goal_uid) { '44e3dedf-e800-4f04-8c13-3ddc8d4437fc' }

    before do
      stub_request(:get, "https://api-sandbox.starlingbank.com/api/v2/account/#{account_uid}/savings-goals/#{saving_goal_uid}").with(
        headers:
      ).to_return(
        body: response_body.to_json,
        status: 200
      )
    end

    it 'returns the saving_goal' do
      expect(subject.fetch(account_uid, saving_goal_uid)).to match(response_body)
      subject
    end
  end

  describe '#transfer_money' do
    let(:amount) { 10 }
    let(:request_body) do
      {
        'amount': {
          'currency': 'GBP',
          'minorUnits': amount
        }
      }
    end

    let(:response_body) do
      { 'transferUid' => '0df15162-db48-4986-a2b0-25dae8678951', 'success' => true }
    end
    let(:saving_goal_uid) { '44e3dedf-e800-4f04-8c13-3ddc8d4437fc' }

    let(:transfer_uid) { 'abcdef-ds-123' }

    before do
      expect(SecureRandom).to receive(:uuid).and_return(transfer_uid)
      stub_request(:put, "https://api-sandbox.starlingbank.com/api/v2/account/#{account_uid}/savings-goals/#{saving_goal_uid}/add-money/#{transfer_uid}").with(
        headers:,
        body: request_body.to_json
      ).to_return(
        body: response_body.to_json,
        status: 200
      )
    end

    it 'returns the transfer uid' do
      expect(subject.transfer_money(account_uid, saving_goal_uid, amount)).to match(response_body)
      subject
    end
  end

  context 'when token is not provided' do
    let(:response_body) do
      {
        'error': 'invalid_token',
        'error_description': 'No access token provided in request. `Header: Authorization` must be set '
      }
    end
    let(:authorization) { 'Bearer' }
    let(:saving_goal_uid) { '44e3dedf-e800-4f04-8c13-3ddc8d4437fc' }

    before do
      stub_request(:get, "https://api-sandbox.starlingbank.com/api/v2/account/#{account_uid}/savings-goals/#{saving_goal_uid}").with(
        headers:
      ).to_return(
        body: response_body.to_json,
        status: 403
      )
      allow(Rails.configuration).to receive(:access_token).and_return('')
    end

    it 'raises an error' do
      expect do
        subject.fetch(account_uid, saving_goal_uid)
      end.to raise_error(RuntimeError, /403: No access token provided in request. `Header: Authorization` must be set/)
    end
  end
end
