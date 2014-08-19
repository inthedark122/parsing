class AddDirectorToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :director, :string
  end
end
