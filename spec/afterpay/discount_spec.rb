require "spec_helper"

RSpec.describe Afterpay::Discount do
  let(:mony) { Money.from_amount(250, "USD") }

  describe ".new" do
    subject do
      Afterpay::Discount.new(name: "New Customer Coupon",
                             amount: mony)
    end
    it { is_expected.to have_attributes(name: "New Customer Coupon") }
    it { is_expected.to have_attributes(amount: mony) }
  end

  describe ".from_response" do
    subject do
      Afterpay::Discount.from_response(displayName: "New Customer Coupon",
                                       amount: { 'amount': "250.00", 'currency': "USD" })
    end
    it { is_expected.to have_attributes(name: "New Customer Coupon") }
    it { is_expected.to have_attributes(amount: mony) }
  end
end
