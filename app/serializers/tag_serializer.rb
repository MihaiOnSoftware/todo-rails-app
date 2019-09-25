# frozen_string_literal: true

class TagSerializer < ActiveModel::Serializer
  attributes :id, :title
  has_many :tasks
end
