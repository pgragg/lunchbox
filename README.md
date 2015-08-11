
#### How to get LunchBox up and running: 

- Lunchbox runs on Heroku at dwight-lunch.herokuapp.com 
- There is an older copy of the site at dwight-lunchbox.herokuapp.com. Don't use this. 
- In order for the app to work, there need to be years and trimesters created. 
  -To test this, log into heroku from the command line and go to the rails console in heroku. 
  -The following series of commands should tell you what you need to know. 
      $heroku run rails console 
      $Year.count            [Should equal 1]
      $Year.first.trimesters.count  [Should equal 3]
  - If these numbers are off, then exit out of console and run 
     $heroku run rake db:reset 
  - This command will run seeds.rb, which will delete all data and reseed the database with 
  - Years, Summaries, Trimesters, and Menus. 
  - The admin will be the first User account, so if you wish to change the information (such as password), do this: 
      $heroku run rails console 
      $admin = User.first 
      $admin.password = "newpassword"
      $admin.save! 
  - You can also create a new admin account from the console. Just check out how it's done on line 162 of 
  - Seeds.rb. 
