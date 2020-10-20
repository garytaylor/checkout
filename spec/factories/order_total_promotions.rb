# frozen_string_literal: true

require 'promotions'
FactoryBot.define do
  factory :order_total_promotion, class: '::Promotions::OrderTotalPromotion' do
    trait :ten_percent_over_60 do
      minimum_value { 6000 }
      discount_amount { 10.0 }
      discount_type { 'Percent' }
    end
  end
end
