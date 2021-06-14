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

def authenticate(account_data)
  ISSInternship::AuthenticateAccount.call(
    username: account_data['username'],
    password: account_data['password']
  )
end

def auth_header(account_data)
  auth = authenticate(account_data)

  "Bearer #{auth[:attributes][:auth_token]}"
end

def authorization(account_data)
  auth = authenticate(account_data)

  contents = AuthToken.contents(auth[:attributes][:auth_token])
  account = contents['attributes']
  # account = contents['payload']['attributes']
  { account: ISSInternship::Account.first(username: account['username']),
    scope: AuthScope.new(contents['scope']) }
end


DATA = {
  accounts: YAML.load(File.read('app/db/seeds/accounts_seeds.yml')),
  companies: YAML.load(File.read('app/db/seeds/companies_seeds.yml')),
  internships: YAML.load(File.read('app/db/seeds/internship_seeds.yml')),
  interviews: YAML.load(File.read('app/db/seeds/interview_seeds.yml'))
}.freeze
