# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RenameTag do
  let(:tag) { FactoryBot.attributes_for(:tag) }
  let(:repository) do
    TagRepository.new.tap do |r|
      r.stub(:tag).and_return(tag)
    end
  end
  let(:rename_tag) { RenameTag.new(repository) }

  it 'does nothing if there is no title given' do
    result = rename_tag.perform(title: nil).value
    expect(result).to eq(tag)
  end

  it 'does nothing if the title is the same' do
    result = rename_tag.perform(title: tag[:title]).value
    expect(result).to eq(tag)
  end

  it 'renames the tag in the repo to the new name' do
    new_title = "I'm new here"
    result = rename_tag.perform(title: new_title).value
    expect(result[:title]).to eq(new_title)
  end

  it 'returns a failure if the title clashes with another in the repo' do
    other_title = "I'm already here!"
    other_tag = FactoryBot.attributes_for(:tag, title: other_title)
    repository.stub(:tag_by_title).with(other_title).and_return(other_tag)
    failure_message = "A tag with the title #{other_title} already exists"
    failure = rename_tag.perform(title: other_title).failure

    expect(failure).to eq(failure_message)
  end
end
