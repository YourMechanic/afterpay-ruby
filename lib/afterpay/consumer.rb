# frozen_string_literal: true

module Afterpay
  class Consumer
    attr_accessor :email, :phone, :first_name, :last_name

    def initialize(attributes = {})
      @email = attributes[:email]
      @phone = attributes[:phone] || ""
      @first_name = attributes[:first_name] || ""
      @last_name = attributes[:last_name] || ""
    end

    def to_hash
      {
        phoneNumber: phone,
        givenNames: first_name,
        surname: last_name,
        email: email
      }
    end

    # Builds Consumer from response
    def self.from_response(response)
      return nil if response.nil?

      new(
        email: response[:email],
        first_name: response[:givenNames],
        last_name: response[:surname],
        phone: response[:phoneNumber]
      )
    end
  end
end
