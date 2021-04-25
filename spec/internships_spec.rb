# frozen_string_literal: true

require_relative './spec_helper'

describe 'Test Document Handling' do
  include Rack::Test::Methods

  before do
    wipe_database

    DATA[:companies].each do |company_data|
      ISSInternship::Company.create(company_data)
    end
  end

  it 'HAPPY: should be able to get list of all internships' do
    comp = ISSInternship::Company.first
    DATA[:internships].each do |intern|
      comp.add_internship(intern)
    end

    get "api/v1/companies/#{proj.id}/internships"
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data'].count).must_equal 2
  end

  it 'HAPPY: should be able to get details of a single internship' do
    intern_data = DATA[:internships][1]
    comp = ISSInternship::Company.first
    intern = comp.add_internship(intern_data).save

    get "/api/v1/companies/#{comp.id}/internships/#{intern.id}"
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data']['attributes']['id']).must_equal intern.id
    _(result['data']['attributes']['title']).must_equal intern_data['title']
    _(result['data']['attributes']['year']).must_equal intern_data['year']
    _(result['data']['attributes']['period']).must_equal intern_data['period']
    _(result['data']['attributes']['job_description']).must_equal intern_data['job_description']
    _(result['data']['attributes']['salary']).must_equal intern_data['salary']
    _(result['data']['attributes']['reactionary']).must_equal intern_data['reactionary']
    _(result['data']['attributes']['recruit_source']).must_equal intern_data['recruit_source']
    _(result['data']['attributes']['rating']).must_equal intern_data['rating']
    _(result['data']['attributes']['ISS_module']).must_equal intern_data['ISS_module']
  end

  it 'SAD: should return error if unknown internship requested' do
    proj = ISSInternship::Company.first
    get "/api/v1/companies/#{comp.id}/internships/foobar"

    _(last_response.status).must_equal 404
  end

  it 'HAPPY: should be able to create new internships' do
    comp = ISSInternship::Company.first
    intern_data = DATA[:internships][1]

    req_header = { 'CONTENT_TYPE' => 'application/json' }
    post "api/v1/companies/#{comp.id}/internships",
         intern_data.to_json, req_header
    _(last_response.status).must_equal 201
    _(last_response.header['Location'].size).must_be :>, 0

    created = JSON.parse(last_response.body)['data']['data']['attributes']
    intern = ISSInternship::Internship.first

    _(created['id']).must_equal intern.id
    _(created['title']).must_equal intern_data['title']
    _(created['year']).must_equal intern_data['year']
    _(created['period']).must_equal intern_data['period']
    _(created['job_description']).must_equal intern_data['job_description']
    _(created['salary']).must_equal intern_data['salary']
    _(created['reactionary']).must_equal intern_data['reactionary']
    _(created['recruit_source']).must_equal intern_data['recruit_source']
    _(created['rating']).must_equal intern_data['rating']
    _(created['ISS_module']).must_equal intern_data['ISS_module']
  end
end