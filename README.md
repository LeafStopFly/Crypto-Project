# Intern Platform
API to store and retrieve confidential development files (configuration, credentials)
## Routes
All routes return Json
- GET /: Root route shows if Web API is running
- GET `api/v1/companies/[company_id]/internships/[internship_id]`: Get an internship reactionary
- GET `api/v1/companies/[company_id]/internships`: Get list of all internships
- POST `api/v1/companies/[company_id]/internships`: Create an new internship

- GET `api/v1/companies/[company_id]/interviews/[interview_id]`: Get an interview reactionary
- GET `api/v1/companies/[company_id]/interviews`: Get list of all interviews
- POST `api/v1/companies/[company_id]/interviews`: Create an new interview

- GET `api/v1/companies/[company_id]`: Get a company information
- GET `api/v1/companies`: Get list of all companies
- POST `api/v1/companies`: Create an new company

## Install
Install this API by cloning the relevant branch and use bundler to install specified gems from `Gemfile.lock`:

```bundle install```

Setup development database once:

```rake db:migrate```

## Test
Setup test database once:

```RACK_ENV=test rake db:migrate```

Run the test specification script in `Rakefile`:

```rake spec```

## Develop/Debug
Add fake data to the development database to work on this project:

```rake db:seed```

## Execute
Launch the API using:

```rake run:dev```

# Release check
Before submitting pull requests, please check if specs, style, and dependency audits pass (will need to be online to update dependency database):

```rake release?```