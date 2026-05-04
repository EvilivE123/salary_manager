class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :job_title, null: false
      t.string :department
      t.string :country, null: false
      t.decimal :salary, precision: 12, scale: 2, null: false
      t.string :currency, default: 'INR'
      t.date :hire_date, null: false
      t.integer :status, default: 0

      t.timestamps
    end
    
    add_index :employees, [:country, :job_title]
    add_index :employees, :salary
    add_index :employees, :department
  end
end
