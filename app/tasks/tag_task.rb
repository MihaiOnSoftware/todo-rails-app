# frozen_string_literal: true

class TagTask
  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def perform(tag_titles:)
    task = repository.task
    return SuccessResult.new(task) unless tag_titles_present(tag_titles)

    update_tags(task, tag_titles)
  end

  private

  def update_tags(task, tag_titles)
    new_tag_titles = new_tag_titles(task, tag_titles)
    new_tags = repository.tags(new_tag_titles)
    missing_tags = new_tag_titles - titles(new_tags)

    repository.create_tags(missing_tags).flat_map do |created_tags|
      tags = (created_tags + new_tags) + existing_tags(task)
      repository.store(task.merge(tags: tags))
    end
  end

  def tag_titles_present(tag_titles)
    tag_titles && !tag_titles.empty?
  end

  def new_tag_titles(task, tag_titles)
    tag_titles - existing_tag_titles(task)
  end

  def existing_tag_titles(task)
    titles(existing_tags(task))
  end

  def existing_tags(task)
    task[:tags] || []
  end

  def titles(tags)
    tags.map { |t| t[:title] }
  end
end
