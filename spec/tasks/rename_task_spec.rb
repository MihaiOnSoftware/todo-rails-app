# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RenameTask do
  let(:task) { FactoryBot.attributes_for(:task) }
  let(:repository) do
    TaskRepository.new.tap do |r|
      r.stub(:task).and_return(task)
    end
  end
  let(:rename_task) { RenameTask.new(repository) }

  it 'does nothing if there is no title given' do
    result = rename_task.perform(title: nil).value
    expect(result[:title]).to eq(task[:title])
  end

  it 'does nothing if the title is the same' do 
    result = rename_task.perform(title: task[:title]).value
    expect(result[:title]).to eq(task[:title])
  end

  it 'renames the task in the repo to the new name' do
    new_title = "Hi, I'm new"

    result = rename_task.perform(title: new_title).value
    expect(result[:title]).to eq(new_title)
  end
end
