# frozen_string_literal: true

class SalesController < ApplicationController
  before_action :authenticate!

  def index
    @sales = current_user.sales.order(created_at: :desc).page params[:page]
    @sales_count = current_user.sales.count
    @total_income = current_user.sales.calculate_income
  end
end
