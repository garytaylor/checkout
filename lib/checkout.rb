# frozen_string_literal: true

require 'promotions'
# The main checkout class
class Checkout
  def initialize(promotional_rules, promotions_calculator: Promotions::CalculatorService)
    @promotional_rules = promotional_rules
    @products = []
    @promotions_applied = []
    @promotions_calculator = promotions_calculator
    @discounts_applied = []
  end

  def scan(product)
    products << product
  end

  def total
    apply_promotions
    (products.sum(&:price) - discounts_applied.sum(&:amount)).round
  end

  private

  attr_reader :promotional_rules, :products, :promotions_calculator, :discounts_applied

  def apply_promotions
    promotions_calculator.call products: products,
                               rules: promotional_rules,
                               discounts_applied: discounts_applied
  end
end
