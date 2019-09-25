# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  let(:title) { 'Today' }
  let(:valid_params) do
    {
      data: {
        id: '1',
        type: 'tags',
        attributes: {
          title: title
        }
      }
    }
  end

  let(:tag_body) do
    {
      id: '1',
      type: 'tags',
      attributes: {
        title: title
      },
      relationships: {
        tasks: {
          data: [
            {
              id: '1',
              type: 'tasks'
            }
          ]
        }
      }
    }
  end

  let(:no_tasks) do
    {
      relationships: {
        tasks: {
          data: []
        }
      }
    }
  end

  let(:task_body) do
    {
      id: '1',
      type: 'tasks',
      attributes: {
        title: 'Wash Laundry'
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

  let(:single_tag_body) do
    {
      data: tag_body,
      included: [task_body]
    }
  end

  let(:invalid_params) do
    skip('Add a hash of attributes invalid for your model')
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns all the tags created' do
      FactoryBot.create(:tag, :with_task)

      get :index, params: {}, session: valid_session
      expect(response).to be_successful
      expected_response = {
        data: [tag_body],
        included: [task_body]
      }
      expect(response.body).to eq(expected_response.to_json)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      tag = FactoryBot.create(:tag, :with_task)

      get :show, params: { id: tag.to_param }, session: valid_session
      expect(response).to be_successful
      expect(response.body).to eq(single_tag_body.to_json)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Tag' do
        expect do
          post :create, params: valid_params, session: valid_session
        end.to change(Tag, :count).by(1)
      end

      it 'renders a JSON response with the new tag' do
        post :create, params: valid_params, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(tag_url(Tag.last))
        expected_response = {
          data: tag_body.merge(no_tasks)
        }
        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new tag' do
        post :create, params: invalid_params, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:updated_title) { 'Updated Tag Title' }

      it 'updates the requested tag' do
        tag = FactoryBot.create(:tag, :with_task)
        update_params = {
          data: {
            id: tag.to_param,
            type: 'tags',
            attributes: {
              title: updated_title
            }
          }
        }
        put :update,
            params: { id: tag.to_param }.merge(update_params),
            session: valid_session
        tag.reload
        expect(tag.title).to eq(updated_title)
      end

      it 'renders a JSON response with the tag' do
        tag = FactoryBot.create(:tag, :with_task)

        put :update,
            params: { id: tag.to_param }.merge(valid_params),
            session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to eq(single_tag_body.to_json)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the tag' do
        tag = FactoryBot.create(:tag, :with_task)

        put :update,
            params: { id: tag.to_param }.merge(invalid_params),
            session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested tag' do
      tag = FactoryBot.create(:tag, :with_task)

      expect do
        delete :destroy, params: { id: tag.to_param }, session: valid_session
      end.to change(Tag, :count).by(-1)
    end
  end
end
