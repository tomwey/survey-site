class ChangeColumnForQuestions < ActiveRecord::Migration
  def up
    rename_column :questions, :type, :type_id
  end

  def down
  end
end
