class CreateApps4allsSites < ActiveRecord::Migration
  def change
    create_table :apps4alls_sites do |t|
      t.integer :page
      t.string :url_site
      t.string :cmp_name
      t.integer :ident
      
      t.timestamps
    end
    
    add_index :apps4alls_sites, :ident, :unique => true
    add_index :apps4alls_sites, :cmp_name
  end
end
