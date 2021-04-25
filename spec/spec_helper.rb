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
end

DATA = {} # rubocop:disable Style/MutableConstant
DATA[:companies] = YAML.safe_load File.read('app/db/seeds/company_seeds.yml')
DATA[:internships] = YAML.safe_load File.read('app/db/seeds/internship_seeds.yml')
DATA[:interviews] = YAML.safe_load File.read('app/db/seeds/interview_seeds.yml')
