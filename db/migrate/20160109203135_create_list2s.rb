class CreateList2s < ActiveRecord::Migration
  def change
    create_table :list2s do |t|
      t.text :title
      t.string :author
      t.string :description
      t.string :delete_code
      t.string :link_id

      t.timestamps
    end
  end
end
