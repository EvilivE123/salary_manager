# rails db:seed
require 'benchmark'

puts "Clearing existing users data..."
User.delete_all # Faster than destroy_all as it skips callbacks
# Admin
User.create!(email: 'admin@example.com', first_name: 'Admin', last_name: 'User', role: :admin, password: 'password123')
# HR Manager
User.create!(email: 'hr@example.com', first_name: 'HR', last_name: 'Manager', password: 'password123')

puts "Clearing existing employee data..."
Employee.delete_all # Faster than destroy_all as it skips callbacks

puts "Loading name dictionaries..."
# chomp: true removes the newline character from each line
first_names = File.readlines(Rails.root.join('db', 'first_names.txt'), chomp: true)
last_names = File.readlines(Rails.root.join('db', 'last_names.txt'), chomp: true)

# Domain Data Arrays for randomization
job_titles = ["Software Engineer", "Data Scientist", "Product Manager", "HR Manager", "UX Designer", "DevOps Engineer"]
departments = ["Engineering", "Data", "Product", "HR", "Design", "Infrastructure"]
countries = ["USA", "UK", "India", "Canada", "Germany", "Australia"]
currencies = { "USA" => "USD", "UK" => "GBP", "India" => "INR", "Canada" => "CAD", "Germany" => "EUR", "Australia" => "AUD" }

# In-memory array to hold the raw hash data
employees_to_insert = []
current_time = Time.current

puts "Generating 10,000 employee records in memory..."
10_000.times do
  country = countries.sample
  employees_to_insert << {
    first_name: first_names.sample,
    last_name: last_names.sample,
    job_title: job_titles.sample,
    department: departments.sample,
    country: country,
    salary: rand(45_000.00..180_000.00).round(2),
    currency: currencies[country],
    hire_date: rand(5.years.ago.to_date..Date.today),
    status: 0, # Map to the 'active' enum integer
    created_at: current_time,
    updated_at: current_time
  }
end

puts "Executing bulk PostgreSQL insertion..."

# Benchmark the database writing process
time = Benchmark.measure do
  # We chunk the array into batches of 2000 to prevent overwhelming 
  # PostgreSQL's query buffer and memory limits.
  employees_to_insert.each_slice(2000) do |slice|
    Employee.insert_all(slice)
  end
end

puts "Successfully seeded 10,000 employees!"
puts "Database insertion time: #{time.real.round(3)} seconds."
