class CreateCashBackRanges < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_back_ranges do |t|
      t.decimal :min_value
      t.decimal :max_value
      t.float :percentage

      t.timestamps
    end
  end
end
