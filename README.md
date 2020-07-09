### System dependencies

* Ruby 2.7.0 (latest version on 09/07/2020)
* [Redis](https://redis.io/topics/quickstart)
* [PostgreSQL v9.5+](https://www.postgresql.org/download/)


### Setup

1. 
Clone the project repository and access it:

    $ git clone https://github.com/gabrielescodino/sales-operation-challenge && cd sales-operation-challenge

2. 
Inside project directory run bundle install in order to fetch all remote sources, resolve dependencies and install all needed gems:

    $ bundle install
3. 
Copy the content of the environment variables sample file and change it with your Google Credentials app info:

    cp .env.example .env
4. 
Set a database.yml file with your credentials. There is a sample file on project. Copy it with:

    cp config/database.yml.sample config/database.yml

5. 
Setup database:

    $ bin/rails db:setup

6. 
Start the Rails app with foreman:

    $ foreman start


### Sales Manager System - Usage
 * When start navigating on system user must login with a Google Account.
 * On `/sales_reports` page user can import new sales report files and check their respective info.
 * To see all sales that were imported on a specfic  report user should click on `view` link on sales reports table. This will redirect system to `/sales_reports/(:id)`.
 * `/sales` page lists all sales imported on system via sales report files by user.

### Future Jobs
* Use Action Cable to real time update sales report status as they are processed on background jobs.
* Improve front-end, especially on sales reports file upload input form.
