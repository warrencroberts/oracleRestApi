class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :key
      t.text :value

      t.timestamps null: false
    end
  end
end
