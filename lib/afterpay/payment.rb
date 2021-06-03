# frozen_string_literal: true

module Afterpay
  # They Payment object
  class Payment
    attr_accessor :id, :token, :status, :created, :original_amount, :open_to_capture_amount,
                  :payment_state, :merchant_reference, :refunds, :order, :events, :error

    # Initialize Payment from response
    def initialize(attributes)
      @id = attributes[:id].to_i
      @token = attributes[:token]
      @status = attributes[:status]
      @created = attributes[:created]
      @original_amount = Utils::Money.from_response(attributes[:originalAmount])
      @open_to_capture_amount = Utils::Money.from_response(attributes[:openToCaptureAmount])
      @payment_state = attributes[:paymentState]
      @merchant_reference = attributes[:merchantReference]
      @refunds = attributes[:refunds]
      @order = Order.from_response(attributes[:orderDetails])
      @events = attributes[:events]
      @error = Error.new(attributes) if attributes[:errorId]
    end

    def success?
      @status == "APPROVED"
    end

    # Executes the Payment
    #
    # @param token [String] the Order token
    # @param reference [String] the reference for payment
    # @return [Payment] the Payment object
    def self.execute(token:, reference:)
      request = Afterpay.client.post("/v2/payments/capture") do |req|
        req.body = {
          token: token,
          merchantRefernce: reference
        }
      end

      new(request.body)
    end

    def self.execute_auth(request_id:, token:, merchant_reference:)
      request = Afterpay.client.post("/v2/payments/auth") do |req|
        req.body = {
          requestId: request_id,
          token: token,
          merchantReference: merchant_reference
        }
      end
      new(request.body)
    end

    def self.execute_deferred_payment(request_id:, reference:, amount:,
                                      payment_event_merchant_reference:, order_id:)
      request = Afterpay.client.post("/v2/payments/#{order_id}/capture") do |req|
        req.body = {
          requestId: request_id,
          merchantRefernce: reference,
          amount: Utils::Money.api_hash(amount),
          paymentEventMerchantReference: payment_event_merchant_reference
        }
      end
      new(request.body)
    end

    def self.execute_void(request_id:, order_id:, amount:)
      request = Afterpay.client.post("/v2/payments/#{order_id}/void") do |req|
        req.body = {
          requestId: request_id,
          amount: Utils::Money.api_hash(amount)
        }
      end
      new(request.body)
    end

    def self.update_shipping_courier(order_id:, shipped_at:, name:, tracking:, priority:)
      request = Afterpay.client.put("/v2/payments/#{order_id}/courier") do |req|
        req.body = {
          shippedAt: shipped_at,
          name: name,
          tracking: tracking,
          priority: priority
        }
      end
      new(request.body)
    end

    def self.get_payment_by_order_id(order_id:)
      request = Afterpay.client.get("/v2/payments/#{order_id}")
      new(request.body)
    end

    # This endpoint retrieves an individual payment along with its order details.
    def self.get_payment_by_token(token:)
      request = Afterpay.client.get("/v2/payments/token:#{token}")
      new(request.body)
    end

    # This end point is for merchants that creates merchant side's order id after
    # AfterPay order id creation. The merchants should call immediately after the
    # AfterPay order is created in order to properly update with their order id
    # that can be tracked.

    def self.update_payment_by_order_id(order_id:, merchant_reference:)
      request = Afterpay.client.put("/v2/payments/#{order_id}") do |req|
        req.body = {
          # The merchant's new order id to replace with
          merchantReference: merchant_reference
        }
      end
      request.body
    end

    # This endpoint performs a reversal of the checkout that is used to initiate
    # the Afterpay payment process. This will cancel the order asynchronously as
    # soon as it is created without the need of an additional call to the void endpoint.
    # In order for a payment to be eligible, the order must be in an Auth-Approved or
    # Captured state and must be issued within 10 minutes of the order being created.
    # token paramater is the token of the checkout to be reversed (voided).

    def self.reverse_payment_by_token(token:)
      request = Afterpay.client.post("/v2/payments/token:#{token}/reversal") do |req|
        req.body = {}
      end
      request.status
    end
  end
end
