# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Database::TagRepositoryDatabase do
  let(:tag) do
    tag = FactoryBot.create(:tag)
    tag.reload
    tag
  end

  let(:repository_database) { Database::TagRepositoryDatabase.new(tag) }
  describe '#tag' do
    it 'will return the given tag record in hash form' do
      result = repository_database.tag
      expect(result).to eq(tag.attributes)
    end
  end

  describe '#tag_by_title' do
    it 'will grab the tag by that title' do
      result = Database::TagRepositoryDatabase.new(nil).tag_by_title(tag.title)
      expect(result).to eq(tag)
    end
  end

  describe '#store' do
    let(:updated_title) { 'updated title' }
    let(:updated_tag) do
      tag.attributes.merge(title: updated_title)
    end

    it 'will return the tag given in hash form' do
      result = repository_database.store(updated_tag).value
      expect(result).to eq(updated_tag)
    end

    it 'will update attribute on the model' do
      repository_database.store(updated_tag)
      tag.reload
      expect(tag.title).to eq(updated_title)
    end

    it 'will return a failure if storage fails' do
      exception = ActiveRecord::ActiveRecordError.new("oops")
      tag.stub(:save!).and_raise(exception)
      failure = repository_database.store(updated_tag).failure
      expect(failure).to eq(exception)
    end
  end
end
