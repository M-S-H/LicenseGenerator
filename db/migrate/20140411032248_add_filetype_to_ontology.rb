class AddFiletypeToOntology < ActiveRecord::Migration
  def change
  	add_column :ontologies, :filetype, :string
  end
end
