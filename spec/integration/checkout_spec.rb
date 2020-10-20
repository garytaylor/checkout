# frozen_string_literal: true

require 'spec_helper'
require 'checkout'
RSpec.describe 'Checkout integration' do
  subject(:checkout) { Checkout.new(promotional_rules) }

  before { basket.each { |item| checkout.scan(item) } }

  context 'with no promotional rules' do
    let(:promotional_rules) { [] }
    let(:basket) do
      [
        build(:product, :lavender_heart),
        build(:product, :personalised_cufflinks)
      ]
    end

    it 'equals the price of the item scanned' do
      expect(checkout.total).to eq basket.sum(&:price)
    end
  end

  context 'with 10 percent off orders over 60 and order below 60' do
    let(:promotional_rules) { [build(:order_total_promotion, :ten_percent_over_60)] }
    let(:basket) do
      [
        build(:product, :lavender_heart),
        build(:product, :personalised_cufflinks)
      ]
    end

    it 'equals the price of the items scanned' do
      expect(checkout.total).to eq basket.sum(&:price)
    end
  end

  context 'with 10 percent off orders over 60 and order equals 60' do
    let(:promotional_rules) { [build(:order_total_promotion, :ten_percent_over_60)] }
    let(:basket) do
      [
        build(:product, :flat_cap),
        build(:product, :personalised_cufflinks)
      ]
    end

    it 'equals the price of the items scanned' do
      expect(checkout.total).to eq basket.sum(&:price)
    end
  end

  context 'with 10 percent off orders over 60 and order is over 60' do
    let(:promotional_rules) { [build(:order_total_promotion, :ten_percent_over_60)] }
    let(:basket) do
      [
        build(:product, :kids_t_shirt),
        build(:product, :personalised_cufflinks)
      ]
    end

    it 'equals the price of the items scanned minus the 10% discount (rounded to nearest)' do
      price_before_discount = basket.sum(&:price)
      expected_discount     = price_before_discount * 0.1
      expected_total        = (price_before_discount - expected_discount).round
      expect(checkout.total).to eq(expected_total)
    end
  end

  context 'with price drop for quantity of 2 lavender hearts but only 1 ordered' do
    let(:promotional_rules) { [build(:product_quantity_promotion, :fixed_price_two_lavender_hearts)] }
    let(:basket) do
      [
        build(:product, :lavender_heart),
        build(:product, :personalised_cufflinks)
      ]
    end

    it 'equals the price of the items scanned' do
      expect(checkout.total).to eq basket.sum(&:price)
    end
  end

  context 'with price drop for quantity of 2 lavender hearts with 2 ordered' do
    let(:promotional_rules) { [build(:product_quantity_promotion, :fixed_price_two_lavender_hearts)] }
    let(:basket) do
      [
        build(:product, :lavender_heart),
        build(:product, :lavender_heart),
        build(:product, :personalised_cufflinks)
      ]
    end

    it 'equals the price of the items scanned minus 75 pence for each lavender heart' do
      expected_discount = 150 # 1.50 GBP
      expect(checkout.total).to eq basket.sum(&:price) - expected_discount
    end
  end

  context 'with 10 percent off orders over 60 and price drop for quantity of 2 lavender hearts' do
    let(:promotional_rules) do
      [build(:order_total_promotion, :ten_percent_over_60),
       build(:product_quantity_promotion, :fixed_price_two_lavender_hearts)]
    end

    context 'with Basket: 001,002,003' do
      let(:basket) do
        [
          build(:product, :lavender_heart),         # Product 001
          build(:product, :personalised_cufflinks), # Product 002
          build(:product, :kids_t_shirt)            # Product 003
        ]
      end

      it 'equals the price of the items scanned minus 75 pence for each lavender heart' do
        expect(checkout.total).to eq 6678
      end
    end

    context 'with Basket: 001,003,001' do
      let(:basket) do
        [
          build(:product, :lavender_heart), # Product 001
          build(:product, :kids_t_shirt),   # Product 003
          build(:product, :lavender_heart)  # Product 001
        ]
      end

      it 'equals the price of the items scanned minus 75 pence for each lavender heart' do
        expect(checkout.total).to eq 3695
      end
    end

    context 'with Basket: 001,002,001,003' do
      let(:basket) do
        [
          build(:product, :lavender_heart),         # Product 001
          build(:product, :personalised_cufflinks), # Product 002
          build(:product, :lavender_heart),         # Product 001
          build(:product, :kids_t_shirt)            # Product 003
        ]
      end

      it 'equals the price of the items scanned minus 75 pence for each lavender heart' do
        expect(checkout.total).to eq 7376
      end
    end
  end
end
