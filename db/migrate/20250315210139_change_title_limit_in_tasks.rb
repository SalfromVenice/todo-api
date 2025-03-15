class ChangeTitleLimitInTasks < ActiveRecord::Migration[8.0]
  def change
    change_column :tasks, :title, :string, limit: 120
  end
end
