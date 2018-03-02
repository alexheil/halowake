class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.references :user
      t.boolean :copper, default: true
      t.boolean :bronze, default: false
      t.string :bronze_id, default: ""
      t.boolean :silver, default: false
      t.string :silver_id, default: ""
      t.boolean :gold, default: false
      t.string :gold_id, default: ""
      t.boolean :platinum, default: false
      t.string :platinum_id, default: ""
      t.string :membership_type, default: "Copper"
      t.integer :amount, default: 0
      t.integer :percent, default: 20

      t.timestamps
    end
  end
end
