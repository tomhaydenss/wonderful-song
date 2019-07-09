# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

position = Position.create(description: 'admin')
Permission::ACTIONS.each do |action|
  Permission::SUBJECTS.each do |subject|
    position.permissions.create(action: action, subject: subject)
  end
end

ensemble_level = EnsembleLevel.create(description: 'standard')
ensemble = Ensemble.create(name: 'standard', ensemble_level: ensemble_level)
member = Member.create(name: 'Admin')
Leadership.create(member: member, position: position, ensemble: ensemble)
User.create(email: 'admin@ongakutai.com.br', password: '123123', member: member)
