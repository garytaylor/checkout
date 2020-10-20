module Promotions
  class DiscountApplied
    attr_reader :amount, :rule

    def initialize(amount:, rule:)
      @amount = amount
      @rule = rule
    end
  end
end
