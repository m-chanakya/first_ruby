class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :tags
      t.string :files
      t.timestamps
    end
  end
end
