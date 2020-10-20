# frozen_string_literal: true

require 'spec_helper'
require 'promotions/calculator_service'
RSpec.describe Promotions::CalculatorService do
  describe '.call' do
    let(:products) do
      [
        build(:product, :lavender_heart),
        build(:product, :lavender_heart),
        build(:product, :personalised_cufflinks),
        build(:product, :kids_t_shirt)
      ]
    end

    context 'with no promotional rules and nothing already applied' do
      subject(:checkout) do
        described_class.call(products: products, rules: [], discounts_applied: discounts_applied)
      end

      let(:discounts_applied) { [] }

      it 'runs without error' do
        checkout
      end
    end

    context 'with 1 product rule and 1 order rule using mocks' do
      subject(:checkout) do
        described_class.call products: products,
                             rules: [order_rule, product_rule],
                             discounts_applied: discounts_applied
      end

      let(:order_rule) do
        attrs = attributes_for(:order_total_promotion, :ten_percent_over_60)
        instance_spy('::Promotions::OrderTotalPromotion', attrs.merge(product_level?: false))
      end
      let(:product_rule) do
        attrs = attributes_for(:product_quantity_promotion, :fixed_price_two_lavender_hearts)
        instance_spy '::Promotions::ProductQuantityPromotion', attrs.merge(product_level?: true)
      end
      let(:discounts_applied) { [] }

      before do
        allow(product_rule).to receive(:apply).with(anything) do |discounts_applied:, **|
          discounts_applied << build(:discount_applied, amount: product_rule.discount_amount, rule: product_rule)
        end
      end

      it 'calls apply on the product rule correctly' do
        checkout
        expect(product_rule).to have_received(:apply)
          .with(products: products, total: products.sum(&:price), discounts_applied: discounts_applied)
      end

      it 'calls apply on the order rule correctly with product discount applied first' do
        expected_total = products.sum(&:price) - product_rule.discount_amount
        checkout
        expect(order_rule).to have_received(:apply)
          .with(products: products, total: expected_total, discounts_applied: discounts_applied)
      end
    end

    context 'with 1 product rule and 1 order rule without mocks' do
      subject(:checkout) do
        described_class.call products: products,
                             rules: rules,
                             discounts_applied: discounts_applied
      end

      let(:rules) do
        [build(:order_total_promotion, :ten_percent_over_60),
         build(:product_quantity_promotion, :fixed_price_two_lavender_hearts)]
      end
      let(:discounts_applied) { [] }

      it 'calls apply on the product rule, the discounts applied subtracted before the call to the order rule' do
        expected_product_discount = 150
        order_total_before_discount = products.sum(&:price) - expected_product_discount
        expected_order_discount = order_total_before_discount * 0.1
        checkout
        expect(discounts_applied.sum(&:amount)).to eq expected_product_discount + expected_order_discount
      end
    end
  end
end
