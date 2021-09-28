# Little Esty Shop + Bulk Discounts

## Table of contents
* [General info](#general-info)
* [Learning Goals](#learning-goals)
* [Technologies](#technologies)
* [Setup](#setup)
* [Schema](#schema)
* [Features](#features)
* [Status](#status)
* [Contact](#contact)

## General Info

"Little Esty Shop" is a group project that requires students to build a fictitious e-commerce platform where merchants and admins can manage inventory and fulfill customer invoices.

Bulk Discounts is a solo extension of the project featuring added functionality fo merchants to create, edit, and delete bulk discounts for their items.

## Learning Goals
- Write migrations to create tables and relationships between tables
- Implement CRUD functionality for a resource using forms (form_tag or form_with), buttons, and links
- Use MVC to organize code effectively, limiting the amount of logic included in views and controllers
- Use built-in ActiveRecord methods to join multiple tables of data, make calculations, and group data based on one or more attributes
- Write model tests that fully cover the data logic of the application
- Write feature tests that fully cover the functionality of the application

## Technologies
Project is created with:
* Ruby version: 2.7.2
* Rails version: 5.2.6

## Setup

* Fork / Clone respository
* From the command line, install gems and set up your DB:
    * `bundle`
    * `rails db:create`
    * `rails db:migrate`
    * `rails csv_load:all`
* Run your development server with `rails s` to see the app in action.


* Or view on Heroku:
[Admin Dashboard](https://mighty-ridge-62010.herokuapp.com/admin) / 
[Example Merchant Dashboard](https://mighty-ridge-62010.herokuapp.com/merchants/1/dashboard)


## Schema
![Schema](https://user-images.githubusercontent.com/826189/135170996-1a6e126f-c78f-4831-8173-32a6f7461cb7.png)

 
## Features
Features ready and to-do list
* Merchant can add, edit, or delete a discount
* Discounted revenue can be viewed by merchants or admin with easy linkage
* Upcoming holidays are viewable on the merchant's bulk_discounts page using [Nager.Date API](https://date.nager.at/swagger/index.html)

To-do list:
* Extensions including limits on when invoices can be edited/deleted, how completed invoices store discounts
* Special holiday discount functionality
* Add Github API info from previous iteration
* Improved routing and styling


## Status
Project is: in-progress


## Contact
Created by

Bulk Discounts:
* [@michaelpmattson](https://github.com/michaelpmattson)

Little Esty Shop:
* [@bdempsey864](https://github.com/bdempsey864)
* [@eakischuk](https://github.com/eakischuk)

~ feel free to contact us! ~
