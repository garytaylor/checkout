# frozen_string_literal: true

require 'spec_helper'
require 'promotions/calculator_service'
RSpec.describe Promotions::CalculatorService do
  describe '.call' do
    let(:below_60_products) do
      [
        build(:product, :lavender_heart),
        build(:product, :personalised_cufflinks)
      ]
    end
    let(:exactly_60_products) do
      [
        build(:product, :flat_cap),
        build(:product, :personalised_cufflinks)
      ]
    end
    let(:over_60_products) do
      [
        build(:product, :kids_t_shirt),
        build(:product, :personalised_cufflinks)
      ]
    end
    context 'with no promotional rules and nothing already applied' do
      subject(:checkout) do
        described_class.call(products: below_60_products, rules: [], discounts_applied: discounts_applied)
      end

      let(:applied) { [] }
      let(:discounts_applied) { [] }

      it 'should not modify discounts_applied' do
        expect { subject }.not_to change(discounts_applied, :length)
      end
    end

    context 'with over 60 promotional rules, nothing already applied and products below 60' do
      subject(:checkout) do
        described_class.call(products: below_60_products, rules: rules, discounts_applied: discounts_applied)
      end

      let(:rules) { [build(:order_total_promotion, :ten_percent_over_60)] }
      let(:applied) { [] }
      let(:discounts_applied) { [] }

      it 'should not modify discounts_applied' do
        expect { subject }.not_to change(discounts_applied, :length)
      end
    end

    context 'with over 60 promotional rules, nothing already applied and products exactly 60' do
      subject(:checkout) do
        described_class.call(products: exactly_60_products, rules: rules, discounts_applied: discounts_applied)
      end

      let(:rules) { [build(:order_total_promotion, :ten_percent_over_60)] }
      let(:applied) { [] }
      let(:discounts_applied) { [] }

      it 'should not modify discounts_applied' do
        expect { subject }.not_to change(discounts_applied, :length)
      end
    end

    context 'with over 60 promotional rules, nothing already applied and products over 60' do
      subject(:checkout) do
        described_class.call(products: products, rules: rules, discounts_applied: discounts_applied)
      end

      let(:products) { over_60_products }
      let(:rules) { [build(:order_total_promotion, :ten_percent_over_60)] }
      let(:applied) { [] }
      let(:discounts_applied) { [] }

      it 'should add a discount to be applied' do
        expected_discount = products.sum(&:price) * 0.1
        subject
        expect(discounts_applied).to contain_exactly an_object_having_attributes amount: expected_discount,
                                                                                 rule: rules.first
      end
    end
  end
end
