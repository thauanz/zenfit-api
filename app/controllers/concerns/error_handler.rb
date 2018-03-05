module Concerns::ErrorHandler
  extend ActiveSupport::Concern

  module InstanceMethods
    Errors = Struct.new(:message) do
      def errors
        { message: message }
      end
    end

    def render_errors(klass, http_status = :unprocessable_entity)
      render partial: 'errors',
        locals: { klass: klass },
        status: http_status
    end
  end

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
end
