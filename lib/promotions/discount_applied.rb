# frozen_string_literal: true

module Promotions
  # A record of a discount applied - both its amount and the rule that applied it
  class DiscountApplied
    attr_reader :amount, :rule

    def initialize(amount:, rule:)
      @amount = amount
      @rule = rule
    end
  end
end
