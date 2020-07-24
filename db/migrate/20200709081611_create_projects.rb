class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
    	t.string :name, null: false
			t.text :description, default: nil
    	t.belongs_to :author, null: false, index: true
      t.timestamps
    end
  end
end
