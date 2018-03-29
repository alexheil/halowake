class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.references :user
      t.string :membership_id, default: ""
      t.string :current_id, default: ""
      t.integer :membership_type, default: 0
      t.integer :percent, default: 20

      t.timestamps
    end
  end
end

