class AddRoleToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :role, :integer, nil: false, default: 0
  end
end
