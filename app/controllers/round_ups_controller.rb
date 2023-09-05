# frozen_string_literal: true

class RoundUpsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @round_up = round_up_amount
    render :json => index_json
  end

  def create
    @round_up_amount = round_up_amount
    @transfer = TransferToSavingGoal.call(account_uid:, amount: round_up_amount)
    render :json => create_json
  end

  private

  def round_up_amount
    @round_up_amount ||= RoundUp.new(account_uid:, category_uid:, min_date:, max_date:).call
  end

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

  def create_json
    {
      "round_up_amount" => round_up_amount,
      "transfer_uid" => @transfer["transferUid"]
    }.to_json
  end
end
