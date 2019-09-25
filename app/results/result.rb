# frozen_string_literal: true

class Result
  def success?
    false
  end

  def map(&_block)
    self
  end

  def value_or_else(&_or_else)
    nil
  end
end
