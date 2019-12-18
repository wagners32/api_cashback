class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.references :user, foreign_key: true
      t.string :code
      t.decimal :value, :precision => 8, :scale => 2
      t.date :purchase_date
      t.decimal :cashback, :precision => 8, :scale => 2
      t.float :cashback_percentual
      t.integer :status

      t.timestamps
    end
  end
end
