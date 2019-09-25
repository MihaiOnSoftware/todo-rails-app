# frozen_string_literal: true

class SuccessResult < Result
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def success?
    true
  end

  def map
    SuccessResult.new(yield value)
  end

  def value_or_else(&_or_else)
    value
  end

  def ==(other)
    other.class == self.class && value == other.value
  end
end
