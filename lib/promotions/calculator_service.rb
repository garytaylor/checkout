# frozen_string_literal: true

module Promotions
  # A service to assist in calculating and applying promotions
  class CalculatorService
    # @param [Array<Product>] products The list of products to purchase
    # @param [Array<OrderTotalPromotion,ProductQuantityPromotion>] rules The promotion rules to apply
    # @param [Array<DiscountApplied>] discounts_applied The discounts that have been applied
    #   at order and product level as a result of the rules
    def self.call(products:, rules:, discounts_applied:)
      rules_to_apply = rules - discounts_applied.map(&:rule) - discounts_applied.map(&:rule)
      product_rules_to_apply, order_rules_to_apply = rules_to_apply.partition(&:product_level?)

      total = products.sum(&:price)
      apply_rules(products, product_rules_to_apply, discounts_applied, total)

      total -= discounts_applied.sum(&:amount)
      apply_rules(products, order_rules_to_apply, discounts_applied, total)
    end

    def self.apply_rules(products, rules_to_apply, discounts_applied, total)
      rules_to_apply.each do |rule|
        rule.apply(products: products, total: total, discounts_applied: discounts_applied)
      end
    end
  end
end
