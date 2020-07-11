# frozen_string_literal: true

class SaleDecorator < ApplicationDecorator
  delegate_all

  def created_at
    object.created_at.strftime('%d/%m/%y - %H:%M')
  end

  def item_price
    h.number_to_currency(sale.item_price / 100.0)
  end
end
