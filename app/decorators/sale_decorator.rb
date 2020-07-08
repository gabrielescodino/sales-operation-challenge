# frozen_string_literal: true

class SaleDecorator < Draper::Decorator
  include Rails.application.routes.url_helpers

  delegate_all

  def created_at
    object.created_at.strftime('%d/%m/%y - %H:%M')
  end

  def item_price
    h.number_to_currency(sale.item_price / 100.0)
  end
end
