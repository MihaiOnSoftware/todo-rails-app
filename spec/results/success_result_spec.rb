# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SuccessResult do
  it 'is a success' do
    SuccessResult.new(nil).should be_success
  end

  it 'has access to the value' do
    expect(SuccessResult.new(1).value).to eq(1)
  end

  it 'will map into another SuccessResult' do
    result = SuccessResult.new(1)
    expect(result.map { |i| i + 1 }).to eq(SuccessResult.new(2))
  end

  it 'will equal another success result with the same value' do
    result1 = SuccessResult.new(1)
    result2 = SuccessResult.new(1)
    expect(result1).to eq(result2)
  end

  it 'will return the vlaue on a value_or_else' do
    result = SuccessResult.new(1)
    expect(result.value_or_else { |e| e }).to eq(1)
  end
end
