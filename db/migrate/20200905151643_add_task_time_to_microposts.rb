class AddTaskTimeToMicroposts < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :task_time, :integer
  end
end
