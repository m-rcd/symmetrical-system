# frozen_string_literal: true

Rails.application.configure do 
  config.access_token = ENV['ACCESS_TOKEN']
  config.bank_api_url = ENV['BANK_API_URL']
end