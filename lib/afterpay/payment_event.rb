# frozen_string_literal: true

module Afterpay
  class PaymentEvent
    attr_accessor :id, :created, :expires, :type, :amount, :payment_event_merchant_reference

    def initialize(attributes = {})
      @id = attributes[:id].to_i || ""
      @created = attributes[:created] || ""
      @expires = attributes[:expires] || ""
      @type = attributes[:expires] || ""
      @amount = Utils::Money.from_response(attributes[:amount]) || Money.from_amount(0)
      @payment_event_merchant_reference = attributes[:paymentEventMerchantReference] || ""
    end

    # Builds PaymentEvent from response
    def self.from_response(response)
      return nil if response.nil?
      new(response)
    end
  end
end
