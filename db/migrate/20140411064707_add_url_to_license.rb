class AddUrlToLicense < ActiveRecord::Migration
  def change
  	add_column :licenses, :url, :string
  end
end
