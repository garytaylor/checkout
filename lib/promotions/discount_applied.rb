# frozen_string_literal: true

module Promotions
  # A record of a discount applied - both its amount and the rule that applied it
  class DiscountApplied
    attr_accessor :amount, :rule

    def initialize(attrs)
      attrs.each_pair do |attr, value|
        send(:"#{attr}=", value) if respond_to?(:"#{attr}=")
      end
    end
  end
end
