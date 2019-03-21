class AddComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :comment_content

      t.references :movie, null: false 
      t.references :user, null: false
    end 
  end
end
