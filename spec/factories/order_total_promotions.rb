# frozen_string_literal: true

FactoryBot.define do
  module Syft
    module Test
      class OrderTotalPromotion
        attr_accessor :minimum_value, :discount_amount, :discount_type
      end
    end
  end

  factory :order_total_promotion, class: Syft::Test::OrderTotalPromotion do
    trait :ten_percent_over_60 do
      minimum_value { 60.0 }
      discount_amount { 10.0 }
      discount_type { 'Percent' }
    end
  end
end
