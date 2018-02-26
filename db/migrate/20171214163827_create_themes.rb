class CreateThemes < ActiveRecord::Migration[5.0]
  def change
    create_table :themes do |t|
      t.references :user
      t.string :main_color, default: ""
      t.string :text_color, default: ""
      t.string :background_color, default: ""
      t.string :link_color, default: ""
      t.string :hover_color, default: ""

      t.timestamps
    end
  end
end
