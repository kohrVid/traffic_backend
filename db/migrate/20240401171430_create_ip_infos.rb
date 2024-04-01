class CreateIpInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :ip_infos do |t|
      t.string :address
      t.decimal :latitude
      t.decimal :longitude
      t.boolean :is_vpn

      t.timestamps
    end
  end
end
