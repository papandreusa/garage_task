class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.integer	:priority, default: 3, null: false
      t.string :status, default: 'unknown', null: false
      t.datetime	:deadline, null: true, default: nil
      t.references :project, index: true
      t.timestamps
    end
  end
end
