# FOMEMA

## Requirements

- ruby 2.6.5
- rails 6.0.3.2
- postgreSQL 12+

## Getting Started
First, change .env.example file name to .env.development and add the following environment variables:
`APP_DOMAIN=localhost.com`
`SUBDOMAIN_MERTS=MERTS-LOCAL`
`SUBDOMAIN_PORTAL=PORTAL-LOCAL`
`SUBDOMAIN_NIOS=NIOS-LOCAL`
`SUBDOMAIN_LABWS=NIOSWS-LOCAL`
`SUBDOMAIN_XRAYWS=FOMWS-LOCAL`

`PUMA_HOST=127.0.0.1`
`PUMA_PORT=3000`


#### Edit /etc/hosts file
`sudo nano /etc/hosts` and add the following lines to the file:

~~~
127.0.0.1       merts-local.localhost.com
127.0.0.1       portal-local.localhost.com
127.0.0.1       nios-local.localhost.com
127.0.0.1       niosws-local.localhost.com
127.0.0.1       fomws-local.localhost.com
~~~

these links will be used to access internal and external sites.
you can change `localhost.com` to any other value but make sure that domain and subdomain are the same as your `.env.development` file

## First Run
1. `bundle install`
2. `rails db:create`
3. `rails db:migrate`
4. `rails db:seed`
5. `rails s -p 3000`

the url to access the project will be:
`[merts-local|portal-local|nios-local].localhost.com:3000`

start sidekiq:
bundle exec sidekiq -q default -q mailers

## migration
# refresh database
drop schema if exists fomema_backup_nios cascade;
drop schema if exists fomema_backup_portal cascade;
drop schema if exists public cascade;
create schema public;

# base migration and seed
cd ~/Sites/fomema
rails db:migrate
rails db:seed prod=1

# create foreign tables to fomema_backup database
cd ~/Sites/fomema/db/seeds/migration/z-prepare-foreign
psql fomema_development -f all.sql

# migrate data from fomema_backup using sql
cd ~/Sites/fomema/db/seeds/migration/3-migrate
psql fomema_development -f main.sql

# insert development user
cd ~/Sites/fomema
rails db:seed file=users

# Web Services
# lab
https://niosws.fomema.my/LabTransactionWS/services/LabTransactionWS?wsdl
# xray
https://fomws.fomema.my/ws/services/TransactionIdService?wsdl

# send reset password email to user
cd ~/Sites/fomema
rake fomema_migrate:reset_user_password where="email ilike 'fonghy@bookdoc.com'"

# uploads files/documents to alibaba
rake upload_files:employer_registration
rake upload_files:fw_amendment
rake upload_files:bulletins

# ubuntu install fonts
sudo add-apt-repository multiverse
sudo apt update && sudo apt install ttf-mscorefonts-installer

# ubuntu install rmagick prerequisites
sudo apt-get install libmagickwand-dev

# AzureStorage cloud monkey-patch
Reference: https://github.com/Azure/azure-storage-ruby/issues/166
1. Add two empty files
    a) lib/azure/storage/core/auth/shared_access_signature.rb
    b) lib/azure/storage.rb
2. Add a new file config/initializers/active_storage_6_patch.rb

### deploy production notes
# backup database
* ssh fomema-uat
screen
cd ~/apps/fomema/current/db/seeds/migration/1-backup-data
psql -U deployer -W fomema_backup -f all-backup.sql 2>&1 | tee -a ~/logs/all-backup-$(date +"%Y%m%d").sql.log

# copy data
* drop all public tables
* drop all public sequences
* ssh fomema-prod-1
cd ~/apps/fomema/current
rails db:migrate
rails db:seed prod=1
cd ~/apps/fomema/current/db/seeds/migration/2-copy-data
psql -U deployer -W --host=pgm-zf8925x192450oh360350.pgsql.kualalumpur.rds.aliyuncs.com --port=1921 fomema -f all.sql 2>&1 | tee -a ~/logs/all-$(date +"%Y%m%d").sql.log

# migrate
cd ~/apps/fomema/current/db/seeds/migration/3-migrate
psql -U deployer -W --host=pgm-zf8925x192450oh360350.pgsql.kualalumpur.rds.aliyuncs.com --port=1921 fomema -f main.sql 2>&1 | tee -a ~/logs/main-$(date +"%Y%m%d").sql.log

# after migration
bundle exec rake fomema_migrate:set_sp_password
bundle exec rake upload_files:employer_registration
bundle exec rake upload_files:fw_amendment
bundle exec rake upload_files:bulletins
bundle exec rake process_vendors:insert
bundle exec rake process_vendors:update
