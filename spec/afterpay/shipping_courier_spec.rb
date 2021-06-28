require "spec_helper"

RSpec.describe Afterpay::ShippingCourier do
  let(:mony) { Money.from_amount(250, "USD") }

  # :shipped_at, :name, :tracking, :priority

  describe ".new" do
    subject do
      Afterpay::ShippingCourier.new(shipped_at: "2019-01-01T00:00:00-08:00", name: "FedEx",
                                    tracking: "000 000 000 000", priority: "STANDARD")
    end
    it { is_expected.to have_attributes(shipped_at: "2019-01-01T00:00:00-08:00") }
    it { is_expected.to have_attributes(name: "FedEx") }
    it { is_expected.to have_attributes(tracking: "000 000 000 000") }
    it { is_expected.to have_attributes(priority: "STANDARD") }
  end

  describe ".from_response" do
    subject do
      Afterpay::ShippingCourier.from_response(shippedAt: "2019-01-01T00:00:00-08:00", name: "FedEx",
                                              tracking: "000 000 000 000", priority: "STANDARD")
    end
    it { is_expected.to have_attributes(shipped_at: "2019-01-01T00:00:00-08:00") }
    it { is_expected.to have_attributes(name: "FedEx") }
    it { is_expected.to have_attributes(tracking: "000 000 000 000") }
    it { is_expected.to have_attributes(priority: "STANDARD") }
  end
end
