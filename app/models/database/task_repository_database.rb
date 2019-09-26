# frozen_string_literal: true

module Database
  class TaskRepositoryDatabase < TaskRepository
    def initialize(task_record)
      @task_record = task_record
    end

    def tags(titles)
      tags = Tag.where(title: titles)
                .map { |t| t.attributes.deep_symbolize_keys }
      tags
    end

    def task
      task_record_to_task(@task_record)
    end

    def create_tags(titles)
      tag_records = []
      unless titles.empty?
        Tag.transaction do
          tag_records = Tag.create!(titles.map { |t| { title: t } })
        end
      end
      tags = tag_records.map { |t| t.attributes.deep_symbolize_keys }
      SuccessResult.new(tags)
    rescue ActiveRecord::ActiveRecordError => e
      FailureResult.new(e)
    end

    def store(task)
      @task_record.transaction do
        @task_record.attributes = task.except(:tags)
        @task_record.tag_ids = task[:tags].map { |t| t[:id] }
        @task_record.save!
      end
      SuccessResult.new(task)
    rescue ActiveRecord::ActiveRecordError => e
      FailureResult.new(e)
    end

    private

    def task_record_to_task(task_record)
      tags = task_record.tags.map(&:attributes)
      task_record.attributes.merge(tags: tags).deep_symbolize_keys
    end
  end
end
