# frozen_string_literal: true

class FailureResult < Result
  attr_reader :failure

  def initialize(failure)
    @failure = failure
  end

  def success?
    false
  end

  def map
    self
  end

  def value_or_else
    yield failure
  end

  def ==(other)
    other.class == self.class && failure == other.failure
  end
end
