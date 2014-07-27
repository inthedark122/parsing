class CreateApps4alls < ActiveRecord::Migration
  def change
    create_table :apps4alls do |t|
      
      t.string :name
      t.string :type_company
      t.string :country
      t.string :city
      t.string :site
      
      t.integer :ios
      t.integer :android
      t.integer :windows
      
      
      t.timestamps
    end
  end
end
