# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :set_task, only: %i[show update destroy]

  # GET /tasks
  def index
    @tasks = Task.all

    render json: @tasks, include: ['tags']
  end

  # GET /tasks/1
  def show
    render json: @task, include: ['tags']
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      render json: @task, include: ['tags'], status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if RenameTask.new(repository).perform(task_params).success?
      render json: @task, include: ['tags']
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def task_params
    ActiveModelSerializers::Deserialization
      .jsonapi_parse!(params, only: [:title])
  end

  def repository
    @repository ||= Database::TaskRepositoryDatabase.new(@task)
  end
end
