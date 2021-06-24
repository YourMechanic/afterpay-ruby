# frozen_string_literal: true

module Afterpay
  class Refund
    attr_accessor :request_id, :amount, :merchant_reference, :refund_id, :refunded_at,
                  :refund_merchant_reference, :error

    def initialize(attributes = {})
      @request_id = attributes[:requestId] || ""
      @amount = attributes[:amount] || Money.from_amount(0)
      @merchant_reference = attributes[:merchantReference] || ""
      @refund_id = attributes[:refundId] || ""
      @refunded_at = attributes[:refundAt] || ""
      @refund_merchant_reference = attributes[:refundMerchantReference] || ""
      @error = Error.new(attributes) if attributes[:errorId]
    end

    def self.execute(order_id:, amount:, request_id: nil, merchant_reference: nil,
                     refund_merchant_reference: nil)
      request = Afterpay.client.post("/v2/payments/#{order_id}/refund") do |req|
        req.body = {
          requestId: request_id,
          amount: Utils::Money.api_hash(amount),
          merchantReference: merchant_reference,
          refundMerchantReference: refund_merchant_reference
        }
      end
      new(request.body)
    end

    # Builds Refund from response
    def self.from_response(response)
      return nil if response.nil?
      new(
        request_id: response[:requestId],
        amount: Utils::Money.from_response(response[:amount]),
        merchant_reference: response[:merchantReference],
        refund_id: response[:refundId],
        refunded_at: response[:refundAt],
        refund_merchant_reference: response[:refundMerchantReference],
        error: Error.new(response)
      )
    end
  end
end
