# frozen_string_literal: true

require "money"

module Afterpay
  class Item
    attr_accessor :name, :sku, :quantity, :page_url, :image_url, :price, :categories, :estimated_shipment_date

    def initialize(attributes = {})
      @name = attributes[:name]
      @sku = attributes[:sku] || ""
      @quantity = attributes[:quantity]
      @price = attributes[:price]
      @page_url = attributes[:page_url] || ""
      @image_url = attributes[:image_url] || ""
      @categories = attributes[:categories] || []
      @estimated_shipment_date = attributes[:estimated_shipment_date] || ""
    end

    def to_hash
      {
        name: name,
        sku: sku,
        quantity: quantity,
        price: {
          amount: price.amount.to_f,
          currency: price.currency.iso_code
        },
        page_url: page_url,
        image_url: image_url,
        categories: categories,
        estimated_shipment_date: estimated_shipment_date
      }
    end

    # Builds Item from response
    def self.from_response(response)
      return nil if response.nil?

      new(
        name: response[:name],
        sku: response[:sku],
        quantity: response[:quantity],
        price: Utils::Money.from_response(response[:price]),
        page_url: response[:pageUrl],
        image_url: response[:imageUrl],
        categories: response[:categories],
        estimated_shipment_date: response[:estimatedShipmentDate]
      )
    end
  end
end
