require "spec_helper"

RSpec.describe Afterpay::Refund do
  let(:mony) { Money.from_amount(250, "USD") }

  describe ".new" do
    subject do
      Afterpay::Refund.new(request_id: "123456", refund_id: "2012020201",
                           refunded_at: "201202020", amount: mony,
                           merchant_reference: "merchant_reference",
                           refund_merchant_reference: "refund_merchant_reference")
    end
    it { is_expected.to have_attributes(request_id: "123456") }
    it { is_expected.to have_attributes(refund_id: "2012020201") }
    it { is_expected.to have_attributes(refunded_at: "201202020") }
    it { is_expected.to have_attributes(amount: mony) }
    it { is_expected.to have_attributes(merchant_reference: "merchant_reference") }
    it { is_expected.to have_attributes(refund_merchant_reference: "refund_merchant_reference") }
  end

  describe ".from_response" do
    subject do
      Afterpay::Refund.from_response(requestId: "123456", refundId: "2012020201",
                                     refundedAt: "201202020", amount: { 'amount': "250.00",
                                                                        'currency': "USD" },
                                     merchantReference: "merchant_reference",
                                     refundMerchantReference: "refund_merchant_reference")
    end
    it { is_expected.to have_attributes(request_id: "123456") }
    it { is_expected.to have_attributes(refund_id: "2012020201") }
    it { is_expected.to have_attributes(refunded_at: "201202020") }
    it { is_expected.to have_attributes(amount: mony) }
    it { is_expected.to have_attributes(merchant_reference: "merchant_reference") }
    it { is_expected.to have_attributes(refund_merchant_reference: "refund_merchant_reference") }
  end
end
