#######################################################################
#                           Fellowships4You                          #
#                       A Ruby on Rails Application                  #
#                       ASCII-Style README                           #
#######################################################################

Welcome to **Fellowships4You**, your gateway to academic excellence through 
scholarships and fellowships! This application is designed with simplicity 
and efficiency in mind. Below is a comprehensive guide to get started.

=======================================================================
                           SETUP INSTRUCTIONS                        
=======================================================================

PREREQUISITES:
--------------
Ensure you have the following installed:
- Ruby 3.1.2
- Rails 7.2.2
- PostgreSQL
- Node.js & Yarn

CLONE THE REPOSITORY:
---------------------
Run the following commands to clone and navigate into the project:
git clone https://github.com/your-repo/fellowships4you.git
cd fellowships4you

INSTALL DEPENDENCIES:
---------------------
Install Ruby and JavaScript dependencies:
bundle install
yarn install

DATABASE SETUP:
---------------
Create and configure the database:
rails db:create
rails db:migrate

(Optional) Seed the database with initial data:
rails db:seed

ENVIRONMENT VARIABLES:
----------------------
Set up a `.env` file in the root directory with the following content:
# Google OAuth
GOOGLE_CLIENT_ID=<your-google-client-id>
GOOGLE_CLIENT_SECRET=<your-google-client-secret>

# Stripe
STRIPE_PUBLISHABLE_KEY=<your-stripe-publishable-key>
STRIPE_SECRET_KEY=<your-stripe-secret-key>
STRIPE_WEBHOOK_SECRET=<your-stripe-webhook-secret>

START THE SERVER:
-----------------
Run the Rails server:
rails server

Visit the app at: http://localhost:3000

=======================================================================
                           PROJECT STRUCTURE                          
=======================================================================

APP STRUCTURE:
--------------
- **app/**: Contains core application files (models, controllers, views, helpers).
- **config/**: Configuration files for the app, including routes and database settings.
- **public/**: Static files, error pages, and the manifest file.
- **db/**: Migrations and schema files for the database.
- **test/**: Test files for the application.
- **notes/**: Project notes and related documents.

=======================================================================
                          USER JOURNEY OVERVIEW                       
=======================================================================

ASCII WIREFRAME:
----------------
Landing Page (/)
┌────────────────────────────────────────────────────────────────┐
│ Fellowships4You                                                │
│ [Sign In with Google] [Explore Scholarships]                  │
│ [Buy Fellowship Guide for $99]                                │
└────────────────────────────────────────────────────────────────┘

Explore Scholarships (/scholarships)
┌────────────────────────────────────────────────────────────────┐
│ List of scholarships (searchable, sortable)                   │
│ [View Details]                                                │
└────────────────────────────────────────────────────────────────┘

Fellowship Guide (/product)
┌────────────────────────────────────────────────────────────────┐
│ Learn how to prepare, apply, and execute plans                │
│ [Buy for $99] (Stripe Checkout)                               │
└────────────────────────────────────────────────────────────────┘

Dashboard (/home)
┌────────────────────────────────────────────────────────────────┐
│ Access exclusive tips, guides, and your bookmarked items      │
│ [View Bookmarks] [Explore More Scholarships]                  │
└────────────────────────────────────────────────────────────────┘

FLOW:
-----
1. Landing Page: Users can sign in via Google, explore scholarships, 
   or purchase the fellowship guide.
2. Scholarship Details: Users can search and bookmark scholarships 
   for later.
3. Purchase Guide: Users are directed to Stripe for secure payment.
4. Dashboard: Access to personalized content for logged-in, paying users.

=======================================================================
                           DEVELOPMENT NOTES                         
=======================================================================

TESTING:
--------
Run all tests:
rails test

LINTING:
--------
Ensure code adheres to style guidelines:
rubocop

CONTINUOUS INTEGRATION:
-----------------------
GitHub Actions are set up to:
- Lint Ruby and JavaScript files.
- Run tests on every push to the `main` branch.

=======================================================================
                          CONTRIBUTION GUIDELINES                     
=======================================================================

We welcome contributions! Please fork the repository, create a feature 
branch, and submit a pull request. Follow the style guidelines and 
include tests for new features.


=======================================================================
                          HAPPY HACKING! 🎉                           
=======================================================================
