User.create!(name: 'Yoda', email: 'yoda@zenfit.com', password: '123456789', role: 'admin')
User.create!(name: 'Anakin', email: 'anakin@zenfit.com', password: '123456789', role: 'manager')

luke = User.create!(name: 'Luke', email: 'luke@zenfit.com', password: '123456789', role: 'regular')
r2 = User.create!(name: 'R2', email: 'r2@zenfit.com', password: '123456789', role: 'regular')

def create_zentimes(user)
  first_day = Date.today - 4.weeks
  (first_day..Date.today).each do |d|
    Zentime.create(date_record: d, time_record: rand(1..200), user: user)
  end
end

create_zentimes(luke)
create_zentimes(r2)
