class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.references :user
      t.string :first_name, default: ""
      t.string :last_name, default: ""
      t.text :image_data
      t.integer :age, default: ""
      t.string :website, default: ""
      t.string :facebook_handle, default: ""
      t.string :facebook_url, default: ""
      t.string :twitter_handle, default: ""
      t.string :twitter_url, default: ""
      t.string :instagram_handle, default: ""
      t.string :instagram_url, default: ""
      t.text :biography, default: ""

      t.timestamps
    end
  end
end
