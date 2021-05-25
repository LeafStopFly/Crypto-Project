# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Company Handling' do
  include Rack::Test::Methods

  before do
    wipe_database
  end

  describe 'Getting companies' do
    it 'HAPPY: should be able to get list of all companies' do
      ISSInternship::Company.create(DATA[:companies][0])
      ISSInternship::Company.create(DATA[:companies][1])

      get 'api/v1/companies'
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['data'].count).must_equal 2
    end

    it 'HAPPY: should be able to get details of a single company' do
      existing_comp = DATA[:companies][1]
      ISSInternship::Company.create(existing_comp)
      id = ISSInternship::Company.first.id

      get "/api/v1/companies/#{id}"
      _(last_response.status).must_equal 200

      result = JSON.parse last_response.body
      _(result['data']['attributes']['id']).must_equal id
      _(result['data']['attributes']['company_no']).must_equal existing_comp['company_no']
      _(result['data']['attributes']['name']).must_equal existing_comp['name']
      _(result['data']['attributes']['address']).must_equal existing_comp['address']

    end

    it 'SAD: should return error if unknown company requested' do
      get '/api/v1/companies/foobar'

      _(last_response.status).must_equal 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do
      ISSInternship::Company.create(name: 'New Company')
      ISSInternship::Company.create(name: 'Newer Company')
      get 'api/v1/companies/2%20or%20id%3E0'

      # deliberately not reporting error -- don't give attacker information
      _(last_response.status).must_equal 404
      _(last_response.body['data']).must_be_nil
    end
  end

  describe 'Creating New Companies' do
    before do
      @req_header = { 'CONTENT_TYPE' => 'application/json' }
      @comp_data = DATA[:companies][1]
    end

    it 'HAPPY: should be able to create new companies' do
      post 'api/v1/companies', @comp_data['company_no'].to_json, @req_header
      _(last_response.status).must_equal 201
      _(last_response.header['Location'].size).must_be :>, 0

      created = JSON.parse(last_response.body)['data']['data']['attributes']
      comp = ISSInternship::Company.first
      
      _(created['id']).must_equal comp.id
      _(created['company_no']).must_equal @comp_data['company_no']
      _(created['name']).must_equal @comp_data['name']
      _(created['address']).must_equal @comp_data['address']
    end
  end
end
