require_relative './makers_orm'

MakersORM.configure do |config|
  config.db_url = 'jdbc:postgresql://localhost:5432/makers_orm_development'
end

class TestModel
  include MakersORM::Model

  property(:first_name, String)
  property(:last_name, String)
  property(:age, Integer)
  property(:email_confirmed, Boolean)
  property(:timestamp, Time)
end

TestModel.create(
  first_name: 'Michael',
  last_name: 'Jacobson',
  age: 29,
  email_confirmed: true,
  timestamp: Time.now
)

me = TestModel.last
p "#{me.first_name} #{me.last_name}"
me.update(first_name: 'Mike')
p "#{me.first_name} #{me.last_name}"
