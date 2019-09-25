# frozen_string_literal: true

class CreateJoinTableTaskTag < ActiveRecord::Migration[5.2]
  def change
    create_join_table :tasks, :tags do |t|
      t.index %i[task_id tag_id]
      t.index %i[tag_id task_id]
    end
  end
end
