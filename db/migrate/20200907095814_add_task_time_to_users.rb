class AddTaskTimeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :task_time, :integer
  end
end
