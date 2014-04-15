class CreateOntologies < ActiveRecord::Migration
  def change
    create_table :ontologies do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
