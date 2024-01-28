# frozen_string_literal: true

# app/decorators/application_decorator.rb
class ApplicationDecorator < Draper::Decorator
  def created_at
    object.created_at.strftime('%A, %B %d, %Y %R')
  end

  def updated_at
    object.updated_at.strftime('%A, %B %d, %Y %R')
  end
end
