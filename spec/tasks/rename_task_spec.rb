# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RenameTask do
  it 'renames the task in the repo to the new name' do
    task = FactoryBot.attributes_for(:task)
    repo = TaskRepository.new.tap do |r|
      r.stub(:task).and_return(task)
    end
    new_title = "Hi, I'm new"

    result = RenameTask.new(repo).perform(title: new_title).value
    expect(result[:title]).to eq(new_title)
  end
end
