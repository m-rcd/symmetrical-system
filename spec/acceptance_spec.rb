# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Acceptance', type: :request do
  before { WebMock.allow_net_connect! }

  describe 'GET /round_up' do
    let(:expected_response) do
      { 'round_up_amount' => '1500 pence (£15.00)' }.to_json
    end

    before { get '/round_up' }

    it 'returns correct response' do
      expect(response).to have_http_status(:success)
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'POST /transfer' do
    before { post '/transfer' }

    it 'returns correct response' do
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['round_up_amount']).to eq('1500 pence (£15.00)')
    end
  end
end
