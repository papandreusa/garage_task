class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string	:priority, default: 'normal', null: false
      t.string :status, default: 'unknown', null: false
      t.datetime	:deadline, null: true
      t.references :project, index: true
      t.timestamps
    end
  end
end
