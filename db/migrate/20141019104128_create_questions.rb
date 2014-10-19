class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.string :tip
      t.integer :type
      t.integer :sort
      t.integer :survey_id

      t.timestamps
    end
    
    add_index :questions, :sort
    add_index :questions, :survey_id
  end
end
