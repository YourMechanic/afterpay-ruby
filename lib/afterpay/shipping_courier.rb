# frozen_string_literal: true

module Afterpay
  class ShippingCourier
    attr_accessor :shipped_at, :name, :tracking, :priority

    def initialize(attributes = {})
      @shipped_at = attributes[:shipped_at] || ""
      @name = attributes[:name] || ""
      @tracking = attributes[:tracking] || ""
      @priority = attributes[:priority] || ""
    end

    # Builds ShippingCourier from response
    def self.from_response(response)
      return nil if response.nil?

      new(
        shipped_at: response[:shippedAt],
        name: response[:name],
        tracking: response[:tracking],
        priority: response[:priority],
        error: Error.new(response)
      )
    end
  end
end
