class CreatePerformances < ActiveRecord::Migration[5.2]
  def change
    create_table :performances do |t|
      t.string :title
      t.date :start_date
      t.date :end_date

      t.timestamps null: false
    end

    add_index :performances, :start_date
    add_index :performances, :end_date
  end
end
