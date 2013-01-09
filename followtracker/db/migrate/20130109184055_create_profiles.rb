class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :title
      t.string :link
      t.string :company

      t.timestamps
    end
  end
end
