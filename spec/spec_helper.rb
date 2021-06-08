# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'yaml'

require_relative 'test_load_all'

def wipe_database
  app.DB[:internships].delete
  app.DB[:interviews].delete
  app.DB[:companies].delete
  app.DB[:accounts].delete
end

def auth_header(account_data)
  auth = ISSInternship::AuthenticateAccount.call(
    username: account_data['username'],
    password: account_data['password']
  )

  "Bearer #{auth[:attributes][:auth_token]}"
end

DATA = {
  accounts: YAML.load(File.read('app/db/seeds/accounts_seeds.yml')),
  companies: YAML.load(File.read('app/db/seeds/companies_seeds.yml')),
  internships: YAML.load(File.read('app/db/seeds/internship_seeds.yml')),
  interviews: YAML.load(File.read('app/db/seeds/interview_seeds.yml'))
}.freeze
