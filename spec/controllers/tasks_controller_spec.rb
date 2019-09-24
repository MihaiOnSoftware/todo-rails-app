# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
  end

  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      _task = Task.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      task = Task.create! valid_attributes
      get :show, params: { id: task.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Task' do
        expect do
          post :create,
               params: { task: valid_attributes },
               session: valid_session
        end.to change(Task, :count).by(1)
      end

      it 'renders a JSON response with the new task' do
        post :create,
             params: { task: valid_attributes },
             session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(task_url(Task.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new task' do
        post :create,
             params: { task: invalid_attributes },
             session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested task' do
        task = Task.create! valid_attributes
        put :update,
            params: { id: task.to_param, task: new_attributes },
            session: valid_session
        task.reload
        skip('Add assertions for updated state')
      end

      it 'renders a JSON response with the task' do
        task = Task.create! valid_attributes

        put :update,
            params: { id: task.to_param, task: valid_attributes },
            session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the task' do
        task = Task.create! valid_attributes

        put :update,
            params: { id: task.to_param, task: invalid_attributes },
            session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested task' do
      task = Task.create! valid_attributes
      expect do
        delete :destroy,
               params: { id: task.to_param },
               session: valid_session
      end.to change(Task, :count).by(-1)
    end
  end
end
