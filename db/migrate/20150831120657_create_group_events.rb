class CreateGroupEvents < ActiveRecord::Migration
  def change
    create_table :group_events do |t|
      t.string :name
      t.string :description
      t.string :location
      t.string :status, default: "draft"
      t.date :start_date
      t.date :end_date
      t.integer :duration
      t.boolean :deleted, default:false

      t.timestamps null: false
    end
  end
end
