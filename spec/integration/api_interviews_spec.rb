# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Interview Handling' do
  include Rack::Test::Methods

  before do
    wipe_database
  end

  describe 'Getting interviews' do
    describe 'Getting list of interviews' do
      before do
        @account_data = DATA[:accounts][0]
        account = ISSInternship::Account.create(@account_data)
        account.add_owned_interview(DATA[:interviews][0])
        account.add_owned_interview(DATA[:interviews][1])
      end

      it 'HAPPY: should get list for authorized account' do
        auth = ISSInternship::AuthenticateAccount.call(
          username: @account_data['username'],
          password: @account_data['password']
        )

        header 'AUTHORIZATION', "Bearer #{auth[:attributes][:auth_token]}"
        get 'api/v1/interviews'
        _(last_response.status).must_equal 200

        result = JSON.parse last_response.body
        _(result['data'].count).must_equal 2
      end

      it 'BAD: should not process for unauthorized account' do
        header 'AUTHORIZATION', 'Bearer bad_token'
        get 'api/v1/interviews'
        _(last_response.status).must_equal 403

        result = JSON.parse last_response.body
        _(result['data']).must_be_nil
      end
    end

    it 'HAPPY: should be able to get details of a single interview' do
      interv_data = DATA[:interviews][1]
      ISSInternship::Interview.create(interv_data)
      id = ISSInternship::Interview.first.id

      get "/api/v1/interviews/#{id}"
      _(last_response.status).must_equal 200

      result = JSON.parse(last_response.body)['attributes']
      _(result['id']).must_equal id
      _(result['position']).must_equal interv_data['position']
      _(result['time']).must_equal interv_data['time']
      _(result['interview_location']).must_equal interv_data['interview_location']
      _(result['level']).must_equal interv_data['level']
      _(result['recruit_source']).must_equal interv_data['recruit_source']
      _(result['rating']).must_equal interv_data['rating']
      _(result['result']).must_equal interv_data['result']
      _(result['description']).must_equal interv_data['description']
      _(result['waiting_result_time']).must_equal interv_data['waiting_result_time']
      _(result['advice']).must_equal interv_data['advice']
      _(result['iss_module']).must_equal interv_data['iss_module']
    end

    it 'SAD: should return error if unknown interview requested' do
      get "/api/v1/interviews/foobar"

      _(last_response.status).must_equal 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do

      ISSInternship::Interview.create({position: 'new position', time: '2021-05-05',
                                       interview_location: 'taipei', level: '難', rating: 3,
                                       result: 'pass', description: 'too hard'})
      ISSInternship::Interview.create({position: 'newer position', time: '2021-05-05',
                                       interview_location: 'taipei', level: '難', rating: 3,
                                       result: 'pass', description: 'too hard'})
      get 'api/v1/internships/2%20or%20id%3E0'

      # deliberately not reporting error -- don't give attacker information
      _(last_response.status).must_equal 404
      _(last_response.body['data']).must_be_nil 
    end
  end

  describe 'Creating Interviews' do
    before do
      @interv_data = DATA[:interviews][1]
      @req_header = { 'CONTENT_TYPE' => 'application/json' }
    end

    it 'HAPPY: should be able to create new interviews' do
      post "api/v1/interviews", @interv_data.to_json, @req_header
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
      post "api/v1/interviews", bad_data.to_json, @req_header

      _(last_response.status).must_equal 400
      _(last_response.header['Location']).must_be_nil
    end
  end
end
