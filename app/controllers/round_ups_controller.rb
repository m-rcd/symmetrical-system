# frozen_string_literal: true

class RoundUpsController < ApplicationController
  protect_from_forgery with: :null_session
  rescue_from  StandardError, with: :show_error
  
  # GET /round_up
  def round_up
    render json: round_up_json
  end

  # POST /transfer
  def transfer
    @transfer = TransferToSavingGoal.call(account_uid:, amount: round_up_amount)
    render json: transfer_json
  end

  private

  def show_error(error)
    render json: { error: error.message }
  end

  def round_up_amount
    @round_up_amount ||= RoundUp.call(account_uid:, category_uid:, min_date:, max_date:)
  end

  def account
    @account ||= BankApi::Accounts.fetch.first
  end

  def account_uid
    request_params['account_uid'] || account['accountUid']
  end

  def min_date
    @min_date ||= (request_params['min_date'] || '02/09/2023').to_datetime
  end

  def max_date
    @max_date ||= (request_params['max_date'] || min_date + 6).to_datetime
  end

  def category_uid
    account['defaultCategory']
  end

  def round_up_json
    { 'round_up_amount' => round_up_amount.to_s }
  end

  def transfer_json
    {
      'round_up_amount' => round_up_amount.to_s,
      'transfer_uid' => @transfer['transferUid']
    }
  end

  def request_params
    params.permit(:account_uid, :min_date, :max_date)
  end
end
