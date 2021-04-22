require 'rack/test'
require 'yaml'

require_relative '../app/controllers/app'
require_relative '../app/models/post'
def app
    Internship::Api
end
  
DATA = YAML.safe_load File.read('app/db/seeds/document_seeds.yml')
Dir.glob("#{Internship::STORE_DIR}/*.txt").each { |postname| FileUtils.rm(postname) }
Internship::Post.new(DATA[1]).save
id = Dir.glob("#{Internship::STORE_DIR}/*.txt").first.split(%r{[/.]})[5]
puts id