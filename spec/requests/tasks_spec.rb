# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'POST /tasks' do
    it 'Posting will show the changes in the index' do
      FactoryBot.create(:task)

      get tasks_path
      initial_index = read_json_file('tasks/index.json').to_json
      expect(response.body).to eq(initial_index)

      post_body = read_json_file('tasks/post.json')
      post tasks_path, params: post_body
      expect(response).to have_http_status(201)

      get tasks_path
      after_post_index = read_json_file('tasks/index_after_post.json').to_json
      expect(response.body).to eq(after_post_index)
    end
  end

  describe 'PATCH /tasks/1' do
    it 'Patching the title will change the show value' do
      task = FactoryBot.create(:task)

      get task_path(task.id)
      initial_show = read_json_file('tasks/show.json').to_json
      expect(response.body).to eq(initial_show)

      title_patch = read_json_file('tasks/patch.json')
      patch task_path(task.id), params: title_patch
      expect(response).to have_http_status(200)

      get task_path(task.id)
      updated_title_show =
        read_json_file('tasks/updated_title_show.json').to_json
      expect(response.body).to eq(updated_title_show)
    end
  end

  def read_json_file(path)
    JSON.parse(file_fixture(path).read)
  end
end
