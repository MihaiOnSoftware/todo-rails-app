# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:title) { 'Wash Laundry' }

  let(:task_body) do
    {
      id: '1',
      type: 'tasks',
      attributes: {
        title: title
      },
      relationships: {
        tags: {
          data: [{
            id: '1',
            type: 'tags'
          }]
        }
      }
    }
  end

  let(:tag_body) do
    {
      id: '1',
      type: 'tags',
      attributes: {
        title: 'Today'
      },
      relationships: {
        tasks: {
          data: [{
            id: '1',
            type: 'tasks'
          }]
        }
      }
    }
  end

  let(:single_task_response) do
    {
      data: task_body,
      included: [tag_body]
    }
  end

  let(:valid_params) do
    {
      data: {
        id: 'undefined',
        type: 'undefined',
        attributes: {
          title: title
        }
      }
    }
  end

  let(:invalid_params) do
    skip('Add a hash of attributes invalid for your model')
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns all tasks' do
      FactoryBot.create(:task, :with_tag)
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
      expected_body = {
        data: [task_body],
        included: [tag_body]
      }
      expect(response.body).to eq(expected_body.to_json)
    end
  end

  describe 'GET #show' do
    it 'returns the task at that id' do
      task = FactoryBot.create(:task, :with_tag)
      get :show, params: { id: task.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response.body).to eq(single_task_response.to_json)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Task' do
        expect do
          post :create,
               params: valid_params,
               session: valid_session
        end.to change(Task, :count).by(1)
      end

      it 'renders a JSON response with the new task' do
        post :create,
             params: valid_params,
             session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(api_v1_task_path(Task.last))
        post_response = {
          data: {
            id: '1',
            type: 'tasks',
            attributes: {
              title: title
            },
            relationships: {
              tags: {
                data: []
              }
            }
          }
        }

        expect(response.body).to eq(post_response.to_json)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new task' do
        post :create,
             params: invalid_params,
             session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:updated_title) { 'Updated Task Title' }

      it 'updates the requested task' do
        task = FactoryBot.create(:task, :with_tag)
        update_params = {
          data: {
            id: task.to_param,
            type: 'tasks',
            attributes: {
              title: updated_title
            }
          }
        }
        put :update,
            params: { id: task.to_param }.merge(update_params),
            session: valid_session
        task.reload
        expect(task.title).to eq(updated_title)
      end

      it 'renders a JSON response with the task' do
        task = FactoryBot.create(:task, :with_tag)
        put :update,
            params: { id: task.to_param }.merge(valid_params),
            session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to eq(single_task_response.to_json)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the task' do
        FactoryBot.create(:task, :with_tag)

        put :update,
            params: invalid_params,
            session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested task' do
      task = FactoryBot.create(:task, :with_tag)
      expect do
        delete :destroy,
               params: { id: task.to_param },
               session: valid_session
      end.to change(Task, :count).by(-1)
    end
  end
end
