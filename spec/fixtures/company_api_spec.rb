# frozen_string_literal: false

require_relative '../spec_helper'

NO = '15725713'.freeze
CORRECT = YAML.safe_load(File.read('spec/fixtures/company_data/company_result.yml'))[0]
describe 'Tests Company API library' do
  it 'HAPPY: should provide correct company attributes' do
    companytest = ISSInternship::CompanyInf::CompanyMapper.new.find(NO)

    _(companytest.company_no).must_equal CORRECT['company_no']
    _(companytest.name).must_equal CORRECT['name']
    _(companytest.address).must_equal CORRECT['address']
    _(companytest.type).must_equal CORRECT['type']
  end
end
