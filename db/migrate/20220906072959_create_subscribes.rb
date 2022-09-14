class CreateSubscribes < ActiveRecord::Migration[7.0]
  def change
    create_table :subscribes, id: :uuid do |t|
      t.string :name, null: false
      t.string :link, null: false

      t.timestamps
    end
  end
end
