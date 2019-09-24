# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  describe 'GET /tags' do
    it 'Getting the tags will give all the tags and relationships' do
      FactoryBot.create(:tag)
      get tags_path
      expect(response).to have_http_status(200)
      expected_body = JSON.parse(file_fixture('tags/index.json').read).to_json
      expect(response.body).to eq(expected_body)
    end
  end
end
