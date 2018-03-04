module Concerns::ErrorHandler
  extend ActiveSupport::Concern

  module InstanceMethods
    def render_errors(klass)
      render partial: 'errors',
        locals: { klass: klass },
        status: :unprocessable_entity
    end
  end

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end
