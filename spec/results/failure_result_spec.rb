# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FailureResult do
  let(:failure_message) { 'I failed' }
  it 'is not a success' do
    FailureResult.new(nil).should_not be_success
  end

  it 'has access to the failure' do
    expect(FailureResult.new(failure_message).failure).to eq(failure_message)
  end

  it 'will return self on a map' do
    result = FailureResult.new(failure_message)
    expect(result.map { |i| i + 1 }).to eq(result)
  end

  it 'will equal another failure result with the same failure' do
    result1 = FailureResult.new(failure_message)
    result2 = FailureResult.new(failure_message)
    expect(result1).to eq(result2)
  end

  it 'will return the else on a value_or_else' do
    result = FailureResult.new(failure_message)
    or_else = "Not the value you're looking for"
    expect(result.value_or_else { |_e| or_else }).to eq(or_else)
  end
end
