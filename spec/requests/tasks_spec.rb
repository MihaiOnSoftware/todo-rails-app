# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  describe 'GET /tasks' do
    it 'Getting the tasks will give all tasks and relationships' do
      FactoryBot.create(:task)
      get tasks_path
      expect(response).to have_http_status(200)
      expected_body = JSON.parse(file_fixture('tasks/index.json').read).to_json
      expect(response.body).to eq(expected_body)
    end
  end
end
