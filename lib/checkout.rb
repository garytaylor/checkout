# frozen_string_literal: true

# The main checkout class
class Checkout
  def initialize(promotional_rules)
    @promotional_rules = promotional_rules
    @products = []
  end

  def scan(product)
    products << product
  end

  def total
    products.sum(&:price)
  end

  private

  attr_reader :promotional_rules, :products
end
