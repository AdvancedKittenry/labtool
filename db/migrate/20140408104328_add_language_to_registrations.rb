class AddLanguageToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :language, :string
  end
end
