class AddListIdToTask < ActiveRecord::Migration[6.1]
  def change
    add_reference :tasks, :list, null: false, foreign_key: true
  end
end
