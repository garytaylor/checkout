# frozen_string_literal: true

require 'promotions'
FactoryBot.define do
  factory :discount_applied, class: '::Promotions::DiscountApplied' do
    association :rule
    amount { 0 }
  end
end
