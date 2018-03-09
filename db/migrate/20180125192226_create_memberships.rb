class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.references :user
      t.string :membership_id, default: ""
      t.string :current_id, default: ""
      t.boolean :copper, default: true
      t.boolean :bronze, default: false
      t.string :bronze_id, default: "bronze_id"
      t.boolean :silver, default: false
      t.string :silver_id, default: "silver_id"
      t.boolean :gold, default: false
      t.string :gold_id, default: "gold_id"
      t.boolean :platinum, default: false
      t.string :platinum_id, default: "platinum_id"
      t.string :membership_type, default: "Copper"
      t.integer :amount, default: 0
      t.integer :percent, default: 20

      t.timestamps
    end
  end
end
