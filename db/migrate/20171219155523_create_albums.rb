class CreateAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :albums do |t|
      t.references :user
      t.string :title
      t.text :description, default: ""
      t.string :slug

      t.timestamps
    end
  end
end
