# frozen_string_literal: true

require 'spec_helper'
require 'checkout'
RSpec.describe Checkout do
  subject(:checkout) { described_class.new(promotional_rules) }

  describe '#scan' do
    let(:promotional_rules) { [] }
    let(:item) { build(:product, :kids_t_shirt) }

    it 'affects the total by the price of the item scanned' do
      checkout.scan(item)
      expect(checkout.total).to eq item.price
    end
  end

  describe '#total' do
    context 'with no promotional rules' do
      let(:promotional_rules) { [] }
      let(:basket) do
        [
          build(:product, :lavender_heart),
          build(:product, :personalised_cuflinks)
        ]
      end
      before { basket.each { |item| checkout.scan(item) }}

      it 'equals the price of the item scanned' do
        expect(checkout.total).to eq basket.sum(&:price)
      end
    end

    context 'with 10 percent off orders over 60 and order below 60' do
      let(:promotional_rules) { build(:order_total_promotion, :ten_percent_over_60) }
      let(:basket) do
        [
          build(:product, :lavender_heart),
          build(:product, :personalised_cuflinks)
        ]
      end
      before { basket.each { |item| checkout.scan(item) }}

      it 'equals the price of the items scanned' do
        expect(checkout.total).to eq basket.sum(&:price)
      end
    end

    context 'with price drop for quantity of 2 lavender hearts' do

    end

    context 'with 10 percent off orders over 60 and price drop for quantity of 2 lavender hearts' do

    end
  end
end
