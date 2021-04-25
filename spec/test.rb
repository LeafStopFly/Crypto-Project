require 'rack/test'
require 'yaml'

require_relative '../app/controllers/app'
require_relative '../app/models/post'
def app
    ISSInternship::Api
end
  
DATA = YAML.safe_load File.read('app/db/seeds/document_seeds.yml')
Dir.glob("#{ISSInternship::STORE_DIR}/*.txt").each { |postname| FileUtils.rm(postname) }
ISSInternship::Post.new(DATA[1]).save
id = Dir.glob("#{ISSInternship::STORE_DIR}/*.txt").first.split(%r{[/.]})[5]
puts id