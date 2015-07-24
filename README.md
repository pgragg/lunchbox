# Lunchbox

To create a "faculty/staff" account, use an @dwight.edu email address. 
To create a "parent" account, use any other email address. 

Lunchbox uses Sendgrid for Devise email confirmations, allowing the app to assign the user a role in the system based on their email address. 

Through Pundit authentication, each user role sees a different face of the application according to their needs. 

Parents can create and manage child accounts, which are automatically assigned to a campus according to their grade level. 

Faculty and Staff can create and manage their own accounts, assign themselves to a campus, and even ask for grade-level delivery. 

The admin panel allows the admin to search all users and children by their attributes, including name, lunches ordered, and sign_in_count. From this menu, the admin can edit user accounts and lunch choices by taking a peek into the user’s own menu. The admin has total control over everything via the admin panel: 

AJAX was used to provide a clear, simple menu interface which highlights for the user how many lunches they have chosen. Eager loading was used to reduce N+1 query time where possible. A JS loading bar was implemented to improve user experience. 

