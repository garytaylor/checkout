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

    end

    context 'with 10 percent off orders over 60' do

    end

    context 'with price drop for quantity of 2 lavender hearts' do

    end

    context 'with 10 percent off orders over 60 and price drop for quantity of 2 lavender hearts' do

    end
  end

end
