# frozen_string_literal: true

class RenameTask
  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def perform(title:)
    task = repository.task
    return SuccessResult.new(task) unless title

    repository.store(task.merge(title: title))
  end
end
