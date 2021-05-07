# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Interview Handling' do
  include Rack::Test::Methods

  before do
    wipe_database

    DATA[:companies].each do |company_data|
      ISSInternship::Company.create(company_data)
    end
  end

  it 'HAPPY: should be able to get list of all interviews' do
    comp = ISSInternship::Company.first
    DATA[:interviews].each do |interv|
      comp.add_interview(interv)
    end

    get "api/v1/companies/#{comp.id}/interviews"
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data'].count).must_equal 2
  end

  it 'HAPPY: should be able to get details of a single interview' do
    interv_data = DATA[:interviews][1]
    comp = ISSInternship::Company.first
    interv = comp.add_interview(interv_data)

    get "/api/v1/companies/#{comp.id}/interviews/#{interv.id}"
    _(last_response.status).must_equal 200

    result = JSON.parse last_response.body
    _(result['data']['attributes']['id']).must_equal interv.id
    _(result['data']['attributes']['position']).must_equal interv_data['position']
    _(result['data']['attributes']['time']).must_equal interv_data['time']
    _(result['data']['attributes']['interview_location']).must_equal interv_data['interview_location']
    _(result['data']['attributes']['level']).must_equal interv_data['level']
    _(result['data']['attributes']['recruit_source']).must_equal interv_data['recruit_source']
    _(result['data']['attributes']['rating']).must_equal interv_data['rating']
    _(result['data']['attributes']['result']).must_equal interv_data['result']
    _(result['data']['attributes']['description']).must_equal interv_data['description']
    _(result['data']['attributes']['waiting_result_time']).must_equal interv_data['waiting_result_time']
    _(result['data']['attributes']['advice']).must_equal interv_data['advice']
    _(result['data']['attributes']['iss_module']).must_equal interv_data['iss_module']
  end

  it 'SAD: should return error if unknown interview requested' do
    comp = ISSInternship::Company.first
    get "/api/v1/companies/#{comp.id}/interviews/foobar"

    _(last_response.status).must_equal 404
  end

  describe 'Creating Interviews' do
    before do
      @comp = ISSInternship::Company.first
      @interv_data = DATA[:interviews][1]
      @req_header = { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'HAPPY: should be able to create new interviews' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post "api/v1/companies/#{@comp.id}/interviews", @interv_data.to_json, req_header
      _(last_response.status).must_equal 201
      _(last_response.header['Location'].size).must_be :>, 0

      created = JSON.parse(last_response.body)['data']['data']['attributes']
      interv = ISSInternship::Interview.first

      _(created['id']).must_equal interv.id
      _(created['position']).must_equal @interv_data['position']
      _(created['time']).must_equal @interv_data['time']
      _(created['interview_location']).must_equal @interv_data['interview_location']
      _(created['level']).must_equal @interv_data['level']
      _(created['recruit_source']).must_equal @interv_data['recruit_source']
      _(created['rating']).must_equal @interv_data['rating']
      _(created['result']).must_equal @interv_data['result']
      _(created['description']).must_equal @interv_data['description']
      _(created['waiting_result_time']).must_equal @interv_data['waiting_result_time']
      _(created['advice']).must_equal @interv_data['advice']
      _(created['iss_module']).must_equal @interv_data['iss_module']
    end

    it 'SECURITY: should not create documents with mass assignment' do
      bad_data = @interv_data.clone
      bad_data['created_at'] = '1900-01-01'
      post "api/v1/companies/#{@comp.id}/interviews", bad_data.to_json, @req_header

      _(last_response.status).must_equal 400
      _(last_response.header['Location']).must_be_nil
    end
  end
end
