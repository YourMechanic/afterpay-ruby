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
  end
end
