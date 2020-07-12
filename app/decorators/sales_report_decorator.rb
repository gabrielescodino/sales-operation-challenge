# frozen_string_literal: true

class SalesReportDecorator < ApplicationDecorator
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
end
