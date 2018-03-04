class CreateZentimes < ActiveRecord::Migration[5.1]
  def change
    create_table :zentimes do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :time_record, null: false
      t.date :date_record, null: false

      t.timestamps
    end
  end
end
