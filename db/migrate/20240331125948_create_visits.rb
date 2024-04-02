class CreateVisits < ActiveRecord::Migration[7.1]
  def change
    create_table :visits do |t|
      t.references :page, foreign_key: true
      t.references :user, foreign_key: true, default: nil, null: true
      t.timestamp :visited_at
      t.string :ip_address

      t.timestamps
    end
  end
end
