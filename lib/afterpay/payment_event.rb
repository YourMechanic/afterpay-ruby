# frozen_string_literal: true

module Afterpay
  class PaymentEvent
    attr_accessor :id, :created, :expires, :type, :amount, :payment_event_merchant_reference

    def initialize(attributes = {})
      @id = attributes[:id] || ""
      @created = attributes[:created] || ""
      @expires = attributes[:expires] || ""
      @type = attributes[:type] || ""
      @amount = attributes[:amount] || Money.from_amount(0)
      @payment_event_merchant_reference = attributes[:payment_event_merchant_reference] || ""
    end

    # Builds PaymentEvent from response
    def self.from_response(response)
      return nil if response.nil?

      new(
        id: response[:id],
        created: response[:created],
        expires: response[:expires],
        type: response[:type],
        amount: Utils::Money.from_response(response[:amount]),
        payment_event_merchant_reference: response[:paymentEventMerchantReference]
      )
    end
  end
end
