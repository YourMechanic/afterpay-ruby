require "spec_helper"

RSpec.describe Afterpay::PaymentEvent do
  let(:mony) { Money.from_amount(250, "USD") }

  describe ".new" do
    subject do
      Afterpay::PaymentEvent.new(id: "123456", created: "201202020",
                                 expires: "201202020", type: "AUTH_APPROVED", amount: mony,
                                 payment_event_merchant_reference: "payment_merchant_ref")
    end
    it { is_expected.to have_attributes(id: "123456") }
    it { is_expected.to have_attributes(created: "201202020") }
    it { is_expected.to have_attributes(expires: "201202020") }
    it { is_expected.to have_attributes(type: "AUTH_APPROVED") }
    it { is_expected.to have_attributes(amount: mony) }
    it { is_expected.to have_attributes(payment_event_merchant_reference: "payment_merchant_ref") }
  end

  describe ".from_response" do
    subject do
      Afterpay::PaymentEvent.from_response(id: "123456", created: "201202020",
                                           expires: "201202020", type: "AUTH_APPROVED", amount: { 'amount': "250.00", 'currency': "USD" },
                                           paymentEventMerchantReference: "payment_merchant_ref")
    end

    it { is_expected.to have_attributes(id: "123456") }
    it { is_expected.to have_attributes(created: "201202020") }
    it { is_expected.to have_attributes(expires: "201202020") }
    it { is_expected.to have_attributes(type: "AUTH_APPROVED") }
    it { is_expected.to have_attributes(amount: mony) }
    it { is_expected.to have_attributes(payment_event_merchant_reference: "payment_merchant_ref") }
  end
end
