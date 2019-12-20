class CreateUserApproveds < ActiveRecord::Migration[5.2]
  def change
    create_table :user_approveds do |t|
      t.string :cpf

      t.timestamps
    end
  end
end
