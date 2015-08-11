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

## v0.65 - Parents with many students (Tuesday, June 15)
- Add Child model 
- Add grade, campus and menu_id to Child 
- Users have many Children
- Children have one User 
- Take away grade, campus, and menu_id from User
- Take away lunch choices from User
- Add Lunch choices to Child. 
- Change routes and views so that menu_id is not necessary in order to access menus page. 
- Add Child controller and child_index view accessible by parents who can see their own children. 
- From the Child_index view, parents should be able to click on the correct menu for their child if child.menu.id != nil.  
- Allow parents to choose menu items for all children. 
- Parents should be able to edit their child's details. 

## v0.7 - Admin menu, signin information, update user model for OU purposes (Friday, June 19)

- Draft the site map and wireframes (1.0);
- Admins should be able to see a list of menus. (0.5);
- Add first + last name, parent email, and campus to user model. Make users create this info on signin (0.5);
- Add teacher? and student? methods and scopes ;
- Add campus scopes for ECD and DWT; 
- Add alphabetical scope for user names; 
- Allow users to edit their account info by clicking on their names.;
- Create and implement method to calculate user's grade based on the first four characters of their email and today's date.;
* Clean up notifications.;
- Users should be automatically routed to the menu associated with them. 


## v0.72 - (Sunday, June 21)

- Heroku soft deploy 
* SimpleForm
* ActiveAdmin
* Parents should see a warning if their child doesn't have a menu_id. 
- Update the rest of this roadmap with new structural considerations.
- Upon first accessing the menu, faculty should be prompted to a define their name and campus. 
- If faculty member has already signed up, they should be able to change their name, campus, grade. 

## v0.8 - Roles, summaries (Friday, June 26)

- Add lunch summaries controller and index pages. 
- Add lunch summaries pages (2.0) ECD students, ECD faculty, DWT students, DWT faculty, Grand totals.; 
- Menus should be available to users according to their role. (2.0).
- Faculty should have a "grade" attribute so we can lump them in with their grade if 1-5. 
- Admins should be able to edit menus. 
- Student menus should include Bagel choices every day, water milk or juice Mon-Thurs, water ch. milk or juice on Fri.
* Faculty should have a "paid" attribute so we don't send lunches to unpaid accounts.
- Clean up controllers. 
- Delete unused partials. 
* Create and enforce permissions for all users. 


## v0.9 (Friday, July 3)

- Add admin panel with access to lunch summaries (2.0) ;
* Allow admin to edit users' lunches from within the admin panel. ;
* Add progress indication to admin panel which lists menus filled out. ;
* Admin should be able to activate and deactivate an account's ability to order. 
- Admin should be able to enter school holidays into the system.  
* Add list of users who have ordered and those who haven’t to the admin panel;
* Only faculty who have paid for lunches should receive them (1.0) ;
N/A Add Google integrated login? https://www.twilio.com/blog/2014/09/gmail-api-oauth-rails.html
- Give Scholastic a sample user login. 
* Load testing (Radview webload or Apache JMeter)
- Student roles should require a parent email so we can send updates to accounts with incomplete menus.
eg. a user model with a student role might have parent_email_1, parent_email_2, and campus.  
- Lunch defaults page : gui for creating lunch options which are available on every day.



## v1.0 Deploy (Friday, July 10)

* Allow admins to add a "bagged lunch" to certain users for certain days, which would make their lunch choice for that day "bagged." 
* A separate totals page would display all bagged lunches for the day. 
N/A Upload student information
* Extensive sanity testing as all user roles.
* Delete testing users.  
* Deploy 

## v1.1 Refactor and redeploy (Friday, July 24)

* Get feedback from Nick, Azra and Scholastic. 
* Refactor based on feedback.
* Error handling : Redirect properly from all errors. 
* Redeploy  

## v1.2 Bug fixing and fun additions (Friday, July 31)

*BUGS LIST 
*ECD teachers list (Summary 7) has mysterious totals for "threes" faculty. 
* Add allergy information to admin panel (2.0) 
* Should be able to reset account paid statuses at any time.
- Add New Relic. 
* Identify slow aspects of site. Fix if possible. 
* Cloudfront for CDN
* Minify JS and CSS if necessary. 
* Batch data access if necessary. 
* Reduce over-fetching if necessary. 
* Refactor to have a single choice class which is inherited by DrinkChoice and LunchChoice. 
* Letter_opener gem to make emails prettier. 


http://stackoverflow.com/questions/24545127/setting-devise-after-sign-in-path-for-with-multiple-models

Git GUI - Sourcetree - Tower 
Heroku GUI - Postico - lets you edit database graphically. 
https://devcenter.heroku.com/articles/connecting-to-heroku-postgres-databases-from-outside-of-heroku

HireFire gem: http://docs.hirefire.io/v1.0/docs/ruby-on-rails-30




### Lunchbox in 60 seconds:
  - Sendgrid for Devise email confirmations. This allows the app to assign the user a role in the system based on their email address. 
  - Pundit authentication, each user role sees a different face of the application according to their needs.
  - AJAX was used to provide a clear, simple menu interface which highlights for the user how many lunches they have chosen. 
  - Eager loading was used to reduce N+1 query time where possible. A JS loading bar was implemented to improve user experience. 
  

#### Admin abilities
  - Search functionality allows the admin to search all users and children by their attributes. 
  - From this menu, the admin can edit user accounts and lunch choices by taking a peek into the user’s own menu. 
  - The admin can easily generate menus for each of four different user groups with one click, and edit items on every menu simultaneously. 
  - 10 different detailed summaries were custom created to fit how the catering kitchen has been operating for decades. 
  
#### Parent abilities
- Parents can create and manage child accounts, which are automatically assigned to a campus according to their grade level. 

#### Faculty and Staff abilities
- Faculty and Staff can create and manage their own accounts, assign themselves to a campus, and arrange for delivery to their homeroom. 


