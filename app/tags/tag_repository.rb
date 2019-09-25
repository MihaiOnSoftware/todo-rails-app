# frozen_string_literal: true

class TagRepository
  def tag_by_title(_title)
    nil
  end

  def tag
    nil
  end

  def store(tag)
    SuccessResult.new(tag)
  end
end
