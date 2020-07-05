# frozen_string_literal: true

class SalesReportDecorator < Draper::Decorator
  include Rails.application.routes.url_helpers

  delegate_all

  def created_at
    object.created_at.strftime('%d/%m/%y - %H:%M')
  end

  def status
    object.status.capitalize
  end

  def income
    h.number_to_currency(object.income / 100.0)
  end

  def input_file
    return nil unless object.input_file.attached?

    h.link_to object.input_file.filename, h.rails_blob_path(sales_report.input_file, disposition: 'attachment')
  end
end
