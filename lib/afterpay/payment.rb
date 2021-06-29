# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

module Afterpay
  # They Payment object
  class Payment
    attr_accessor :id, :token, :status, :created, :original_amount, :open_to_capture_amount,
                  :payment_state, :merchant_reference, :refunds, :order, :events, :error

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity

    # Initialize Payment from response
    def initialize(attributes = {})
      @id = attributes[:id] || ""
      @token = attributes[:token] || ""
      @status = attributes[:status] || ""
      @created = attributes[:created] || ""
      @original_amount = Utils::Money.from_response(attributes[:originalAmount]) || Money.from_amount(0)
      @open_to_capture_amount = Utils::Money.from_response(attributes[:openToCaptureAmount]) || Money.from_amount(0)
      @payment_state = attributes[:paymentState] || ""
      @merchant_reference = attributes[:merchantReference] || ""
      @refunds = attributes[:refunds].map { |refund| Refund.from_response(refund) } || [] unless attributes[:refunds].nil?
      @order = Order.from_response(attributes[:orderDetails]) || Afterpay::Order.new
      @events = attributes[:events].map { |event| PaymentEvent.from_response(event) } || [] unless attributes[:events].nil?
      @error = Error.new(attributes) if attributes[:errorId]
    end

    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

    def success?
      @status == "APPROVED"
    end

    # Executes the Payment
    #
    # @param token [String] the Order token
    # @param merchant_reference [String] the merchant_reference for payment
    # @return [Payment] the Payment object
    def self.execute(token:, merchant_reference: nil)
      request = Afterpay.client.post("/v2/payments/capture") do |req|
        req.body = {
          token: token,
          merchantReference: merchant_reference
        }
      end
      new(request.body)
    end

    def self.execute_auth(token:, request_id: nil, merchant_reference: nil)
      request = Afterpay.client.post("/v2/payments/auth") do |req|
        req.body = {
          requestId: request_id,
          token: token,
          merchantReference: merchant_reference
        }
      end
      new(request.body)
    end

    def self.execute_deferred_payment(amount:, order_id:, request_id: nil, merchant_reference: nil,
                                      payment_event_merchant_reference: nil)
      request = Afterpay.client.post("/v2/payments/#{order_id}/capture") do |req|
        req.body = {
          requestId: request_id,
          merchantReference: merchant_reference,
          amount: Utils::Money.api_hash(amount),
          paymentEventMerchantReference: payment_event_merchant_reference
        }
      end
      new(request.body)
    end

    def self.execute_void(order_id:, amount:, request_id: nil)
      request = Afterpay.client.post("/v2/payments/#{order_id}/void") do |req|
        req.body = {
          requestId: request_id,
          amount: Utils::Money.api_hash(amount)
        }
      end
      new(request.body)
    end

    def self.update_shipping_courier(order_id:, shipped_at: nil, name: nil, tracking: nil, priority: nil)
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

    # This endpoint retrieves an individual payment along with its order details.
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

    def self.create_url(url, type, values)
      if values.size.positive?
        values.each do |value|
          url += "&#{type}=#{value}"
        end
      end
      url
    end

    # rubocop:disable Metrics/ParameterLists

    # This endpoint retrieves a collection of payments along with their order details.
    def self.list_payments(tokens:, ids:, merchant_ref:, statuses:, to_created_date: nil, from_created_date: nil, limit: nil, offset: nil, order_by: nil, asc: nil)
      url = "/v2/payments?"
      url += "toCreatedDate=#{to_created_date.gsub('+', '%2b')}" if to_created_date
      url += "&fromCreatedDate=#{from_created_date.gsub('+', '%2b')}" if from_created_date
      url += "&limit=#{limit}" if limit
      url += "&offset=#{offset}" if offset
      url += "&orderBy=#{order_by}" if order_by
      url += "&ascending=#{asc}" if asc
      url += create_url(url, "ids", ids)
      url += create_url(url, "tokens", tokens)
      url += create_url(url, "merchantReferences", merchant_ref)
      url += create_url(url, "statuses", statuses)
      request = Afterpay.client.get(url)
      request.body
    end

    # rubocop:enable Metrics/ParameterLists
  end
end

# rubocop:enable Metrics/ClassLength
