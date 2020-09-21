class AddBreakTimeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :break_time, :integer
  end
end
