# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

ASCII Wireframe for F-Rad (Ruby on Rails):
------------------------------------------
Landing Page (/) => sign in or buy => /product => create checkout => Stripe => 
webhook => Payment => /home => see content.

   LANDING PAGE:
   ┌────────────────────────────────────────────────────────────────┐
   │ F-Rad Fellowship Planner (multiple CTAs)                      │
   │   [Sign In w/ Google]  [Buy $99 => post /buy]                 │
   └────────────────────────────────────────────────────────────────┘
                    ↓
   PRODUCT PAGE (/product):
   ┌────────────────────────────────────────────────────────────────┐
   │ Modules: Explore, Prepare, Execute                            │
   │   - "Buy $99" => post /buy => Stripe checkout                 │
   └────────────────────────────────────────────────────────────────┘
                    ↓
   STRIPE WEBHOOK (/stripe/webhook):
   ┌────────────────────────────────────────────────────────────────┐
   │ If event= checkout.session.completed => Payment.create(...)    │
   └────────────────────────────────────────────────────────────────┘
                    ↓
   HOME PAGE (/home):
   ┌────────────────────────────────────────────────────────────────┐
   │ If Payment found => show advanced content, else redirect.      │
   └────────────────────────────────────────────────────────────────┘

Usage:
1) rails s
2) visit http://localhost:3000
3) Create "payments" table already done by generator + migrations.
4) Google OAuth => /auth/google_oauth2
5) Happy hacking!

