class AddTaskToMicroposts < ActiveRecord::Migration[5.2]
  def change
    add_column :microposts, :task, :string
  end
end
