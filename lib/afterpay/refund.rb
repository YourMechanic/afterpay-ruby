# frozen_string_literal: true

module Afterpay
  class Refund
    attr_accessor :request_id, :amount, :merchant_reference, :refund_id, :refunded_at,
                  :refund_merchant_reference, :error

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity

    def initialize(attributes = {})
      @request_id = attributes[:request_id] || ""
      @amount = attributes[:amount] || Money.from_amount(0)
      @merchant_reference = attributes[:merchant_reference] || ""
      @refund_id = attributes[:refund_id] || ""
      @refunded_at = attributes[:refunded_at] || ""
      @refund_merchant_reference = attributes[:refund_merchant_reference] || ""
      @error = Error.new(attributes[:error]) if attributes[:error] && attributes[:error][:errorId]
    end

    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

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
      from_response(request.body)
    end

    def success?
      @error.nil?
    end

    # Builds Refund from response
    def self.from_response(response)
      return nil if response.nil?

      new(
        request_id: response[:requestId],
        amount: Utils::Money.from_response(response[:amount]),
        merchant_reference: response[:merchantReference],
        refund_id: response[:refundId],
        refunded_at: response[:refundedAt],
        refund_merchant_reference: response[:refundMerchantReference],
        error: response
      )
    end
  end
end
