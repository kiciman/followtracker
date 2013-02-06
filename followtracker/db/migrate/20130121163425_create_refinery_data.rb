class CreateRefineryData < ActiveRecord::Migration
  def change
    create_table :refinery_data do |t|
      t.string :name
      t.string :country
      t.string :city
      t.string :company
      t.integer :capacity
      t.string :supply
      t.integer :complexity

      t.timestamps
    end
  end
end
