# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BankApi::Accounts do
  subject { described_class.fetch }

  let(:headers) do
    {
      'Accept' => 'application/json',
      'Authorization' => authorization,
      'Content-Type' => 'application/json'
    }.compact
  end

  context 'when token is provided' do
    let(:authorization) { "Bearer #{Rails.configuration.access_token}" }
    let(:body) do
      {
        'accounts': [
          {
            'accountUid': 'be7290c6-88bb-49c4-9615-ec94b28e1c4fs',
            'accountType': 'PRIMARY',
            'defaultCategory': 'be7279f7-ddda-4faa-8c33-e60c14922b06',
            'currency': 'GBP',
            'createdAt': '2023-09-03T15:14:04.066Z',
            'name': 'Personal'
          }
        ]
      }
    end

    let(:expected_accounts) do
      [
        {
          'accountUid' => 'be7290c6-88bb-49c4-9615-ec94b28e1c4fs',
          'accountType' => 'PRIMARY',
          'defaultCategory' => 'be7279f7-ddda-4faa-8c33-e60c14922b06',
          'currency' => 'GBP',
          'createdAt' => '2023-09-03T15:14:04.066Z',
          'name' => 'Personal'
        }
      ]
    end

    before do
      stub_request(:get, "#{Rails.configuration.bank_api_url}/accounts").with(
        headers:
      ).to_return(
        body: body.to_json,
        status: 200
      )
    end

    it 'returns the accounts' do
      expect(subject).to match(expected_accounts)
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
      stub_request(:get, "#{Rails.configuration.bank_api_url}/accounts").with(
        headers:
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
