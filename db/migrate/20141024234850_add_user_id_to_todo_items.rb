class AddUserIdToTodoItems < ActiveRecord::Migration
  def change
    change_table :todo_items do |t|
      t.integer :user_id
    end
  end
end
