# LunchBox - The Dwight School Lunch Ordering App 

## v0.5

- Add FactoryGirl 
* Revise capybara feature spec lunch choice create and delete: turn it into a creation spec
- Document user stories (1.0);
- Get 'path/invalid', to: redirect('/'); (Deal with links)
- Add AJAX to lunch order creation and deletion  http://www.gotealeaf.com/blog/the-detailed-guide-on-how-ajax-works-with-ruby-on-rails (1.0);
* Route back to home page when you encounter a validation error. (Devise docs - override devise routes with variables)

## v0.6 - Capybara

* Add Capybara testing to signing up, lunch order creation and deletion. https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
* Delete or refactor generated Rspec tests 
* Test models in console (1.0);
* Write RSpec specs for models (3.0);

## v0.7 - Admin menu, signin information, update user model for OU purposes 

* Draft the site map and wireframes (1.0);
* Admins should be able to create menus. (0.5);
* Add first + last name, parent email, and campus to user model. Make users to create this info on signin (0.5);
* Add teacher? and student? methods and scopes ;
* Add campus scopes for ECD and DWT; 
* Add alphabetical scope for user names; 
* Allow users to edit their account info by clicking on their names.;
* Create method to calculate user's grade based on the first four characters of their email and today's date.;
* Clean up notifications.

## v0.8 - Refactor

* Clean up controllers. 
* Delete unused partials. 
* 

## v0.9 - Roles, summaries


* Add lunch summaries pages (2.0) ECD students, ECD faculty, DWT students, DWT faculty, Grand totals.; 
* Menus should be available to users according to their role. (2.0).
* Student menus should include Bagel choices every day, water milk or juice Mon-Thurs, water ch. milk or juice on Fri. 
* Student roles should require a parent email so we can send updates to unpaid accounts. 
* Students AND faculty should have a "paid" attribute so we don't send lunches to unpaid accounts.
* Should be able to reset all account paid statuses on June 15. 

## v1.0

* Add admin panel with access to lunch summaries (2.0) ;
* Allow admin to edit users lunches from within the admin panel. ;
* Add progress indication to admin panel which lists menus filled out. ;
* Add list of users who have ordered and those who haven’t to the admin panel;
* Add ability for an Admin to create a new menu from the admin panel.;
* Fix the look of the site (4.0);
* Only faculty who have paid for lunches should receive them (1.0) ;
* Add Google integrated login? https://www.twilio.com/blog/2014/09/gmail-api-oauth-rails.html
* Give Scholastic a sample user login. 


## v1.1

* Add allergy information to admin panel (2.0) 
* Allow admins to add a "bagged lunch" to certain users for certain days, which would make their lunch choice for that day "bagged." A seperate totals page would display all bagged lunches for the day. 






