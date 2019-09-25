# frozen_string_literal: true

class RenameTag
  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def perform(title:)
    tag = repository.tag
    return SuccessResult.new(tag) if title.nil? || title == tag[:title]

    other_tag = repository.tag_by_title(title)
    return tag_title_taken_failure(title) unless other_tag.nil?

    repository.store(tag.merge(title: title))
  end

  def tag_title_taken_failure(title)
    FailureResult.new("A tag with the title #{title} already exists")
  end
end
