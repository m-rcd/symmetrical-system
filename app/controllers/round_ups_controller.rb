# frozen_string_literal: true

class RoundUpsController < ApplicationController
  def index
    @round_up = RoundUp.new(account_uid:, category_uid:, min_date:, max_date:).call
    render :json => index_json
  end

  private

  def account
    @account ||= StarlingApi::Account.fetch.first
  end

  def account_uid
    account['accountUid']
  end

  def min_date
    @min_date ||= DateTime.new(2023, 9, 0o3).beginning_of_week
  end

  def max_date
    @max_date ||= DateTime.new(2023, 9, 0o3).end_of_week
  end

  def category_uid
    account['defaultCategory']
  end

  def index_json 
   {
     "round_up" => @round_up
   }.to_json
  end
end
