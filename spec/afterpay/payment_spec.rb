require "spec_helper"

RSpec.describe Afterpay::Payment do
  describe ".execute" do
    it "returns a payment", :vcr do
      token = "q3f6gn81q09gfjk7riaqfhavmtebt88qpjepd9kmjo37ou7oj5eb"
      payment = described_class.execute(token: token, reference: "checkout-1")

      expect(payment.success?).to be true
      expect(payment).to be_a Afterpay::Payment
      expect(payment.order).to be_a Afterpay::Order
      expect(payment.error).to be_nil
    end

    context "invalid token" do
      it "returns error", :vcr do
        token = "tgiibd59adl9rldhefaqm9jcgnhca8dvv07t9gcq7lboo6btsdfq"
        payment = described_class.execute(token: token, reference: "checkout-1")

        expect(payment).to be_a Afterpay::Payment
        expect(payment.success?).to be false
        expect(payment.error).not_to be_nil
      end
    end
  end

  describe ".execute_auth" do
    let(:merchant_reference) { "100101468" }

    it "returns a payment", :vcr do
      token = "002.avpv776th25fof4itbfvrc019dqje4ia27qjk5525o3mfosr"
      payment = described_class.execute_auth(request_id: "fjfwwwjfj0902929210", token: token,
                                             merchant_reference: merchant_reference)

      expect(payment.success?).to be true
      expect(payment.payment_state).to eq("AUTH_APPROVED")
      expect(payment).to be_a Afterpay::Payment
      expect(payment.order).to be_a Afterpay::Order
      expect(payment.error).to be_nil
    end

    context "invalid order token" do
      it "returns error", :vcr do
        token = "tgiibd59adl9rldhefaqm9jcgnhca8dvv07t9gcq7lboo6btsdfq11"
        payment = described_class.execute_auth(request_id: "fjfwwwjfj0902929210", token: token,
                                               merchant_reference: merchant_reference)

        expect(payment).to be_a Afterpay::Payment
        expect(payment.success?).to be false
        expect(payment.error).not_to be_nil
      end
    end
  end

  describe ".execute_deferred_payment" do
    let(:merchant_reference) { "100101468" }
    let(:mony) { Money.from_amount(250, "USD") }
    let(:valid_order_id) { 100101529842 }

    it "returns a payment", :vcr do
      payment = described_class.execute_deferred_payment(request_id: "wert100101529590",
                                                         reference: merchant_reference, amount: mony,
                                                         payment_event_merchant_reference: "", order_id: valid_order_id)

      expect(payment.success?).to be true
      expect(payment).to be_a Afterpay::Payment
      expect(payment.order).to be_a Afterpay::Order
      expect(payment.error).to be_nil
    end

    context "invalid order ID" do
      it "returns error", :vcr do
        payment = described_class.execute_deferred_payment(request_id: "wert100101529590",
                                                           reference: merchant_reference, amount: mony,
                                                           payment_event_merchant_reference: "", order_id: valid_order_id + 1)

        expect(payment).to be_a Afterpay::Payment
        expect(payment.success?).to be false
        expect(payment.error).not_to be_nil
      end
    end
  end

  describe ".execute_void" do
    let(:mony) { Money.from_amount(250, "USD") }
    let(:valid_order_id) { 100101529842 }

    it "returns a payment", :vcr do
      payment = described_class.execute_void(request_id: "some_uniqe_val",
                                             order_id: valid_order_id, amount: mony)

      expect(payment).to be_a Afterpay::Payment
      expect(payment.error).to be_nil
    end
  end

  describe ".update_shipping_courier" do
    let(:valid_order_id) { 100101529842 }

    it "returns a payment object", :vcr do
      payment = described_class.update_shipping_courier(order_id: valid_order_id,
                                                        shipped_at: DateTime.now.iso8601,
                                                        name: "Bludart", tracking: "AWB129181", priority: "EXPRESS")

      expect(payment).to be_a Afterpay::Payment
      expect(payment.error).to be_nil
    end
  end

  describe ".get_payment_by_order_id" do
    let(:valid_order_id) { 100101529842 }

    it "fetches a payment object by its order_id", :vcr do
      payment = described_class.get_payment_by_order_id(order_id: valid_order_id)

      expect(payment).to be_a Afterpay::Payment
      expect(payment.id).to eq(100101529842)
      expect(payment.error).to be_nil
    end
  end

  describe ".get_payment_by_token" do
    let(:valid_token) { "002.avpv776th25fof4itbfvrc019dqje4ia27qjk5525o3mfosr" }

    it "fetches a payment object by its token", :vcr do
      payment = described_class.get_payment_by_token(token: valid_token)

      expect(payment).to be_a Afterpay::Payment
      expect(payment.error).to be_nil
    end
  end
end
