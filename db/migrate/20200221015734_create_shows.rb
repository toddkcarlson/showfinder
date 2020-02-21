class CreateShows < ActiveRecord::Migration[5.1]
  def change
    create_table :shows do |t|
      t.string :image
      t.string :title
      t.text :starring
      t.timestamps
    end
  end
end
