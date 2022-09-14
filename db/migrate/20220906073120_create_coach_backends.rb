class CreateCoachBackends < ActiveRecord::Migration[7.0]
  def change
    create_table :coach_backends do |t|
      t.belongs_to :coach, type: :uuid, null: false, foreign_key: true
      t.belongs_to :backend, type: :uuid, null: false, foreign_key: true
      t.boolean :enabled, default: false
    end
  end
end
