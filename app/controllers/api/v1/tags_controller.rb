# frozen_string_literal: true

module Api
  module V1
    class TagsController < ApplicationController
      before_action :set_tag, only: %i[show update destroy]

      # GET /tags
      def index
        @tags = Tag.all

        render json: @tags, include: ['tasks']
      end

      # GET /tags/1
      def show
        render json: @tag, include: ['tasks']
      end

      # POST /tags
      def create
        @tag = Tag.new

        if rename_tag.perform(tag_params).success?
          render(
            json: @tag, 
            include: ['tasks'], 
            status: :created, 
            location: api_v1_tag_path(@tag)
          )
        else
          render json: @tag.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /tags/1
      def update
        if rename_tag.perform(tag_params).success?
          render json: @tag, include: ['tasks']
        else
          render json: @tag.errors, status: :unprocessable_entity
        end
      end

      # DELETE /tags/1
      def destroy
        @tag.destroy
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_tag
        @tag = Tag.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def tag_params
        ActiveModelSerializers::Deserialization
          .jsonapi_parse!(params, only: [:title])
      end

      def repository
        @repository ||= Database::TagRepositoryDatabase.new(@tag)
      end

      def rename_tag
        RenameTag.new(repository)
      end
    end
  end
end
