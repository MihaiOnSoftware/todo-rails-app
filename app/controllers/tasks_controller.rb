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
    result = rename_task.perform(title: task_params[:title]).map do
      tag_task.perform(tag_titles: task_params[:tags])
    end
    if result.success?
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
      .jsonapi_parse!(params, only: %i[title tags])
  end

  def repository
    @repository ||= Database::TaskRepositoryDatabase.new(@task)
  end

  def rename_task
    RenameTask.new(repository)
  end

  def tag_task
    TagTask.new(repository)
  end
end
