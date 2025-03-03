# frozen_string_literal: true

require 'product'
FactoryBot.define do
  factory :product do
    trait :lavender_heart do
      code     { "001" }
      name     { "Lavender heart" }
      price    { 925 }
      currency { 'GBP' }
    end

    trait :personalised_cufflinks do
      code     { "002" }
      name     { "Personalised cufflinks" }
      price    { 4500 }
      currency { 'GBP' }
    end

    trait :kids_t_shirt do
      code     { "003" }
      name     { "Kids T-shirt" }
      price    { 1995 }
      currency { 'GBP' }
    end

    trait :flat_cap do
      code     { "004" }
      name     { "A flat cap to make the amount up to 60" }
      price    { 1500 }
      currency { 'GBP' }
    end
  end
end
