# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Result do
  it 'can be a success, but not by default' do
    Result.new.should_not be_success
  end

  it 'will not map' do
    result = Result.new
    expect(result.map { |i| i + 1 }).to be(result)
  end

  it 'will return nil on value_or_else' do
    result = Result.new
    expect(result.value_or_else { |e| e }).to be_nil
  end
end
