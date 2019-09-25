# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Database::TaskRepositoryDatabase do
  let(:task_record) do
    task_record = FactoryBot.create(:task)
    task_record.reload
    task_record
  end
  let(:database) { Database::TaskRepositoryDatabase.new(task_record) }

  describe '#task' do
    it 'returns the task record given in hash form' do
      expected = task_record.attributes.merge(tags: []).deep_symbolize_keys
      expect(database.task).to eq(expected)
    end

    it 'inlcudes the tags' do
      tag = FactoryBot.create(:tag)
      task_record.tags << tag
      tag.reload
      expected = task_record
                 .attributes
                 .merge(tags: [tag.attributes])
                 .deep_symbolize_keys

      expect(database.task).to eq(expected)
    end
  end

  describe '#tags' do
    it "returns tags' attributes that match the given titles" do
      tag_titles = %w[Urgent Home]
      tags = tag_titles.map do |title|
        FactoryBot.create(:tag, title: title)
      end
      result = database.tags(tag_titles)

      tags.each(&:reload)
      expected = tags.map { |t| t.attributes.deep_symbolize_keys }
      expect(result).to match_array(expected)
    end
  end

  describe '#store' do
    let(:tag_record) { FactoryBot.create(:tag) }
    let(:new_title) { 'A Whole New Title' }

    let(:task_to_store) do
      task_record.attributes.merge(
        title: new_title,
        tags: [tag_record.attributes]
      ).deep_symbolize_keys
    end

    it 'returns the result of the store in hash form' do
      result = database.store(task_to_store).value
      expect(result).to eq(task_to_store)
    end

    it 'stores the task' do
      database.store(task_to_store)
      task_record.reload

      expect(task_record.title).to eq(new_title)
    end

    it 'stores the tag associations' do
      database.store(task_to_store)
      task_record.reload

      expect(task_record.tags.to_a).to eq([tag_record])
    end
  end
end
