# frozen_string_literal: true

class PaginateDecorator < Draper::CollectionDecorator
  delegate :current_page, :total_pages, :limit_value, :offset_value, :last_page?
end
