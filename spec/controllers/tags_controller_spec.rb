# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  let(:valid_attributes) do
    {
      title: 'Today'
    }
  end

  let(:tag_body) do
    {
      id: '1',
      type: 'tags',
      attributes: {
        title: 'Today'
      }
    }
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns all the tags created' do
      Tag.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
      expected_response = {
        data: [tag_body]
      }
      expect(response.body).to eq(expected_response.to_json)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      tag = Tag.create! valid_attributes
      get :show, params: { id: tag.to_param }, session: valid_session
      expect(response).to be_successful
      expected_response = {
        data: tag_body
      }
      expect(response.body).to eq(expected_response.to_json)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Tag' do
        expect do
          post :create, params: { tag: valid_attributes }, session: valid_session
        end.to change(Tag, :count).by(1)
      end

      it 'renders a JSON response with the new tag' do
        post :create, params: { tag: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(tag_url(Tag.last))
        expected_response = {
          data: tag_body
        }
        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new tag' do
        post :create, params: { tag: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:updated_title) { 'Updated Tag Title' }
      let(:new_attributes) do
        {
          title: updated_title
        }
      end

      it 'updates the requested tag' do
        tag = Tag.create! valid_attributes
        put :update, params: { id: tag.to_param, tag: new_attributes }, session: valid_session
        tag.reload
        expect(tag.title).to eq(updated_title)
      end

      it 'renders a JSON response with the tag' do
        tag = Tag.create! valid_attributes

        put :update, params: { id: tag.to_param, tag: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
        expected_response = {
          data: tag_body
        }
        expect(response.body).to eq(expected_response.to_json)
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the tag' do
        tag = Tag.create! valid_attributes

        put :update, params: { id: tag.to_param, tag: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested tag' do
      tag = Tag.create! valid_attributes
      expect do
        delete :destroy, params: { id: tag.to_param }, session: valid_session
      end.to change(Tag, :count).by(-1)
    end
  end
end
