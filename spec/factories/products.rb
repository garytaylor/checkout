FactoryBot.define do
  class Syft::Test::Product
    attr_accessor :code, :name, :price, :currency
  end

  factory :product, class: Syft::Test::Product do
    trait :lavender_heart do
      code     { "001" }
      name     { "Lavender heart" }
      price    { 925 }
      currency { 'GBP' }
    end

    trait :personalised_cuflinks do
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
  end
end
