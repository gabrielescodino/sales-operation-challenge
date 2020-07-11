# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  include Rails.application.routes.url_helpers

  def self.collection_decorator_class
    PaginateDecorator
  end
end
