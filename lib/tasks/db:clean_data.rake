namespace :db do
  desc "Cleans all sample seed data except that which is necessary to run the app."
  task clean_data: :environment do
    Lunch.delete_all
    User.delete_all #Deleting all your data before a reset is pretty much necessary. 
    Child.delete_all
    LunchChoice.delete_all
    admin = User.new(
      first_name: 'Scholastic',
      last_name:  'Eat',
      email:      'scholastic@gmail.com',
      password:   'eatwell',
      role:       'admin'
      )

      admin.skip_confirmation!
      admin.save!
    end

end
