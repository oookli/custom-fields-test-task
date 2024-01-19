class CreateUserCustomFields < ActiveRecord::Migration[7.1]
  def change
    create_table :user_custom_fields do |t|
      t.belongs_to :user, null: false, foreign_key: { delete: :cascade }
      t.string :name, null: false
      t.string :internal_name, null: false
      t.string :type, default: 0, limit: 4, null: false

      t.timestamps
    end
  end
end