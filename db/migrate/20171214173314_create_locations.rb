class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.references :user
      t.string :city, default: ""
      t.string :state, default: ""
      t.string :country, default: ""

      t.timestamps
    end
  end
end
