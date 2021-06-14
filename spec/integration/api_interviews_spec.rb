# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Interview Handling' do
  include Rack::Test::Methods

  before do
    wipe_database

    @account_data = DATA[:accounts][0]
    @wrong_account_data = DATA[:accounts][1]

    @account = ISSInternship::Account.create(@account_data)
    @wrong_account = ISSInternship::Account.create(@wrong_account_data)

    header 'CONTENT_TYPE', 'application/json'
  end

  describe 'Getting interviews' do
    describe 'Getting list of interviews' do
      before do
        @account.add_owned_interview(DATA[:interviews][0])
        @account.add_owned_interview(DATA[:interviews][1])
      end

      it 'HAPPY: should get list for authorized account' do
        header 'AUTHORIZATION', auth_header(@account_data)
        get 'api/v1/interviews'
        _(last_response.status).must_equal 200

        result = JSON.parse last_response.body
        _(result['data'].count).must_equal 2
      end

      it 'BAD: should not process without authorization' do
        get 'api/v1/interviews'
        _(last_response.status).must_equal 403

        result = JSON.parse last_response.body
        _(result['data']).must_be_nil
      end

      it 'HAPPY: everyone should get process for unauthorized account' do
        get 'api/v1/all_interviews'
        _(last_response.status).must_equal 200

        result = JSON.parse last_response.body
        _(result['data'].count).must_equal 2
      end
    end

    it 'HAPPY: should be able to get details of a single interview' do
      interv_data = @account.add_owned_interview(DATA[:interviews][0])
      id = interv_data.id

      header 'AUTHORIZATION', auth_header(@account_data)
      get "/api/v1/interviews/#{id}"
      _(last_response.status).must_equal 200

      result = JSON.parse(last_response.body)['data']['attributes']
      _(result['id']).must_equal id
      _(result['position']).must_equal interv_data.position
      _(result['time']).must_equal interv_data.time
      _(result['interview_location']).must_equal interv_data.interview_location
      _(result['level']).must_equal interv_data.level
      _(result['recruit_source']).must_equal interv_data.recruit_source
      _(result['rating']).must_equal interv_data.rating
      _(result['result']).must_equal interv_data.result
      _(result['description']).must_equal interv_data.description
      _(result['waiting_result_time']).must_equal interv_data.waiting_result_time
      _(result['advice']).must_equal interv_data.advice
      _(result['iss_module']).must_equal interv_data.iss_module
      _(result['company_name']).must_equal interv_data.company_name
      _(result['non_anonymous']).must_equal interv_data.non_anonymous
    end

    it 'SAD: should return error if unknown interview requested' do
      header 'AUTHORIZATION', auth_header(@account_data)
      get "/api/v1/interviews/foobar"

      _(last_response.status).must_equal 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do

      @account.add_owned_interview(DATA[:interviews][0])
      @account.add_owned_interview(DATA[:interviews][1])

      header 'AUTHORIZATION', auth_header(@account_data)
      get 'api/v1/internships/2%20or%20id%3E0'

      # deliberately not reporting error -- don't give attacker information
      _(last_response.status).must_equal 404
      _(last_response.body['data']).must_be_nil 
    end
  end

  describe 'Creating Interviews' do
    before do
      @interv_data = DATA[:interviews][1]
    end

    it 'HAPPY: should be able to create new interviews' do
      header 'AUTHORIZATION', auth_header(@account_data)
      post "api/v1/interviews", @interv_data.to_json
      _(last_response.status).must_equal 201
      _(last_response.header['Location'].size).must_be :>, 0

      created = JSON.parse(last_response.body)['data']['attributes']
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
      header 'AUTHORIZATION', auth_header(@account_data)
      post "api/v1/interviews", bad_data.to_json

      _(last_response.status).must_equal 400
      _(last_response.header['Location']).must_be_nil
    end
  end
end
