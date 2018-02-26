class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.references :user
      t.boolean :copper, default: true
      t.boolean :bronze, default: false
      t.boolean :silver, default: false
      t.boolean :gold, default: false
      t.boolean :platinum, default: false
      t.string :membership_type, default: "Copper"
      t.integer :amount, default: 0
      t.integer :percent, default: 20

      t.timestamps
    end
  end
end
