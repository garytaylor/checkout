# frozen_string_literal: true

require 'promotions'
FactoryBot.define do
  factory :product_quantity_promotion, class: ::Promotions::ProductQuantityPromotion do
    trait :fixed_price_two_lavender_hearts do
      product_code { '001' }
      minimum_quantity { 2 }
      discount_amount { 75 }
      discount_type { 'FixedAmount' }
    end
  end
end
