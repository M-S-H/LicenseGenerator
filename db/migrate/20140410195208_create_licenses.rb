class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :name
      t.integer :ontology_id

      t.timestamps
    end
  end
end
