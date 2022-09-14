class CreateCoaches < ActiveRecord::Migration[7.0]
  def change
    create_table :coaches, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.integer :target, null: false
      t.jsonb :options, default: {}
      t.string :encrypt_value

      t.timestamps
    end
  end
end
