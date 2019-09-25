# frozen_string_literal: true

module Database
  class TagRepositoryDatabase < TagRepository
    def initialize(tag_record)
      @tag_record = tag_record
    end

    def tag
      @tag_record.attributes
    end

    def tag_by_title(title)
      Tag.find_by(title: title)
    end

    def store(tag)
      @tag_record.attributes = tag
      @tag_record.save!
      SuccessResult.new(tag)
    rescue ActiveRecord::ActiveRecordError => e
      FailureResult.new(e)
    end
  end
end
