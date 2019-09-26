# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagTask do
  it "won't do anything if there are no tags to tag" do
    task = FactoryBot.attributes_for(:task)
    result = TagTask.new(repository(task)).perform(tag_titles: nil).value
    expect(result).to eq(task)
  end

  it 'will create missing tags' do
    original_tag = FactoryBot.attributes_for(:tag)

    task = FactoryBot.attributes_for(:task, tags: [original_tag])
    tag_titles = %w[Home Urgent]
    new_tags = tag_titles.map do |t|
      FactoryBot.attributes_for(:tag, title: t)
    end

    repo = repository(task).tap do |r|
      r.stub(:create_tags).with(tag_titles).and_return(SuccessResult.new(new_tags))
    end

    result = TagTask.new(repo).perform(tag_titles: tag_titles)
    expect(result.value[:tags]).to match_array(new_tags + [original_tag])
  end

  it 'will add the given tags to the task' do
    task = FactoryBot.attributes_for(:task)
    tag_titles = %w[Home Urgent]
    tags = tag_titles.map do |title|
      FactoryBot.attributes_for(:tag, title: title)
    end

    repo = repository(task).tap do |r|
      r.stub(:tags).with(tag_titles).and_return(tags)
    end

    result = TagTask.new(repo).perform(tag_titles: tag_titles).value
    expect(result[:tags]).to match_array(tags)
  end

  it "won't overwrite existing tags" do
    initial_tag = FactoryBot.attributes_for(:tag)
    task = FactoryBot.attributes_for(:task, tags: [initial_tag])
    tag_titles = %w[Home Urgent]
    new_tags = tag_titles.map do |title|
      FactoryBot.attributes_for(:tag, title: title)
    end
    all_tags = new_tags + [initial_tag]

    repo = repository(task).tap do |r|
      r.stub(:tags).with(tag_titles).and_return(new_tags)
    end

    result = TagTask.new(repo).perform(tag_titles: tag_titles).value
    expect(result[:tags]).to match_array(all_tags)
  end

  it "won't add tags that are already on the task" do
    initial_tag = FactoryBot.attributes_for(:tag)
    task = FactoryBot.attributes_for(:task, tags: [initial_tag])
    tag_titles = %w[Home Urgent]
    new_tags = tag_titles.map do |title|
      FactoryBot.attributes_for(:tag, title: title)
    end
    all_tags = new_tags + [initial_tag]
    all_tag_titles = tag_titles + [initial_tag[:title]]

    repo = repository(task).tap do |r|
      r.stub(:tags).with(tag_titles).and_return(new_tags)
    end

    result = TagTask.new(repo).perform(tag_titles: all_tag_titles).value
    expect(result[:tags]).to match_array(all_tags)
  end

  def repository(task)
    TaskRepository.new.tap do |r|
      r.stub(:task).and_return(task)
    end
  end
end
