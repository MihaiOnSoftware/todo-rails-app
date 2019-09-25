# frozen_string_literal: true

class TaskRepository
  def tags(_titles)
    []
  end

  def task
    nil
  end

  def store(task)
    SuccessResult.new(task)
  end
end
