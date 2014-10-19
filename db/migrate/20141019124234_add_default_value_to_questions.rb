class AddDefaultValueToQuestions < ActiveRecord::Migration
  def change
    change_column :questions, :sort, :integer, :default => 0
  end
end
