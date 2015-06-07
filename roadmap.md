# LunchBox - The Dwight School Lunch Ordering App 

## v0.5 (Tuesday, May 26)

- Add FactoryGirl 
- Revise capybara feature spec lunch choice create and delete: turn it into a creation spec
- Document user stories (1.0);
- Get 'path/invalid', to: redirect('/'); (Deal with links)
- Add AJAX to lunch order creation and deletion  http://www.gotealeaf.com/blog/the-detailed-guide-on-how-ajax-works-with-ruby-on-rails (1.0);
+/- Route back to home page when you encounter a validation error. (Devise docs - override devise routes with variables)

## v0.6 - Capybara (Tuesday, June 02)

- Add Capybara testing to signing in and signing up
* Add Capybara testing to lunch order creation and deletion. https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara
- Delete or refactor generated Rspec tests 
- Test models in console (1.0);
* Write RSpec specs for models (3.0);

## v0.7 - Admin menu, signin information, update user model for OU purposes (Friday, June 19)

- Draft the site map and wireframes (1.0);
- Admins should be able to see a list of menus. (0.5);
* Add first + last name, parent email, and campus to user model. Make users create this info on signin (0.5);
* Add teacher? and student? methods and scopes ;
* Add campus scopes for ECD and DWT; 
* Add alphabetical scope for user names; 
* Allow users to edit their account info by clicking on their names.;
* Create method to calculate user's grade based on the first four characters of their email and today's date.;
* Clean up notifications.;
* Users should be automatically routed to the menu associated with them. 


## v0.72 - Refactor (Friday, June 26)

* Clean up controllers. 
* Delete unused partials. 
* Create and enforce permissions for all users. 

## v0.8 - Roles, summaries (Friday, July 3)

- Add lunch summaries controller and index pages. 
* Add lunch summaries pages (2.0) ECD students, ECD faculty, DWT students, DWT faculty, Grand totals.; 
* Menus should be available to users according to their role. (2.0).
* Student menus should include Bagel choices every day, water milk or juice Mon-Thurs, water ch. milk or juice on Fri.  
* Faculty should have a "paid" attribute so we don't send lunches to unpaid accounts.
* Faculty should have a "grade" attribute so we can lump them in with their grade if 1-5. 


## v0.9 (Friday, July 10)

* Add admin panel with access to lunch summaries (2.0) ;
* Allow admin to edit users lunches from within the admin panel. ;
* Add progress indication to admin panel which lists menus filled out. ;
* Admin should be able to activate and deactivate an account's ability to order. 
* Admin should be able to enter school holidays into the system.  
* Add list of users who have ordered and those who haven’t to the admin panel;
* Add ability for an Admin to create a new menu from the admin panel.;
* Fix the look of the site (4.0);
* Only faculty who have paid for lunches should receive them (1.0) ;
* Add Google integrated login? https://www.twilio.com/blog/2014/09/gmail-api-oauth-rails.html
* Give Scholastic a sample user login. 
* Load testing (Radview webload or Apache JMeter)
* Student roles should require a parent email so we can send updates to accounts with incomplete menus.
eg. a user model with a student role might have parent_email_1, parent_email_2, and campus.  


## v1.0 Deploy (Friday, July 17)

* Allow admins to add a "bagged lunch" to certain users for certain days, which would make their lunch choice for that day "bagged." 
* A seperate totals page would display all bagged lunches for the day. 
* Upload student information
* Extensive sanity testing as all user roles.
* Delete testing users.  
* Deploy 

## v1.1 Refactor and redeploy (Friday, July 24)

* Get feedback from Nick, Azra and Scholastic. 
* Refactor based on feedback.
* Redeploy  

## v1.2 Bug fixing and fun additions (Friday, July 31)

* Add allergy information to admin panel (2.0) 
* Should be able to reset account paid statuses at any time.
* Add New Relic. 
* Identify slow aspects of site. Fix if possible. 
* Cloudfront for CDN
* Minify JS and CSS if necessary. 
* Batch data access if necessary. 
* Reduce over-fetching if necessary. 


http://stackoverflow.com/questions/24545127/setting-devise-after-sign-in-path-for-with-multiple-models



