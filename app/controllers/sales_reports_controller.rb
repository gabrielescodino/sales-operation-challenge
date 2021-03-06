# frozen_string_literal: true

class SalesReportsController < ApplicationController
  before_action :authenticate!

  def create
    sales_report = SalesReport.create!(user_id: current_user.id, input_file: sales_report_params[:input_file])
    sales_report.enqueue_process!

    redirect_back(fallback_location: sales_reports_path,
                  notice: I18n.t('controllers.sales_reports.create.redirect_message'))
  end

  def index
    @sales_reports = current_user.sales_reports.order(created_at: 'desc').page(params[:page]).decorate
    @sales_reports_count = current_user.sales_reports.count
  end

  def show
    @sales_report = current_user.sales_reports.finished.find(params[:id]).decorate
    @sales = @sales_report.sales.page params[:page]
    @sales_count = current_user.sales.count
  end

  private

  def sales_report_params
    params.require(:sales_report).permit(:input_file)
  end
end
