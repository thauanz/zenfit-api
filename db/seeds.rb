User.create!(name: 'Yoda', email: 'yoda@zenfit.com', password: '123456789', role: 'admin')
User.create!(name: 'Anakin', email: 'anakin@zenfit.com', password: '123456789', role: 'manager')

user = User.create!(name: 'Luke', email: 'luke@zenfit.com', password: '123456789', role: 'regular')

first_day = Date.today - 10.day
(first_day..Date.today).each do |d|
  Zentime.create(date_record: d, time_record: rand(1..200), user: user)
end
