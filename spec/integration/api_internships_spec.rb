# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Internship Handling' do
  include Rack::Test::Methods

  before do
    wipe_database
  end

  describe 'Getting internships' do
    describe 'Getting list of internships' do
      before do
        @account_data = DATA[:accounts][0]
        account = ISSInternship::Account.create(@account_data)
        account.add_owned_internship(DATA[:internships][0])
        account.add_owned_internship(DATA[:internships][1])
      end

      it 'HAPPY: should get list for authorized account' do
        auth = ISSInternship::AuthenticateAccount.call(
          username: @account_data['username'],
          password: @account_data['password']
        )

        header 'AUTHORIZATION', "Bearer #{auth[:attributes][:auth_token]}"
        get 'api/v1/internships'
        _(last_response.status).must_equal 200

        result = JSON.parse last_response.body
        _(result['data'].count).must_equal 2
      end

      it 'BAD: should not process for unauthorized account' do
        header 'AUTHORIZATION', 'Bearer bad_token'
        get 'api/v1/internships'
        _(last_response.status).must_equal 403

        result = JSON.parse last_response.body
        _(result['data']).must_be_nil
      end
    end

    it 'HAPPY: should be able to get details of a single internship' do
      intern_data = DATA[:internships][1]
      ISSInternship::Internship.create(intern_data)
      id = ISSInternship::Internship.first.id

      get "/api/v1/internships/#{id}"
      _(last_response.status).must_equal 200

      result = JSON.parse(last_response.body)['attributes']
      _(result['id']).must_equal id
      _(result['title']).must_equal intern_data['title']
      _(result['year']).must_equal intern_data['year']
      _(result['period']).must_equal intern_data['period']
      _(result['job_description']).must_equal intern_data['job_description']
      _(result['salary']).must_equal intern_data['salary']
      _(result['reactionary']).must_equal intern_data['reactionary']
      _(result['recruit_source']).must_equal intern_data['recruit_source']
      _(result['rating']).must_equal intern_data['rating']
      _(result['iss_module']).must_equal intern_data['iss_module']
    end

    it 'SAD: should return error if unknown internship requested' do
      get '/api/v1/internships/foobar'

      _(last_response.status).must_equal 404
    end

    it 'SECURITY: should prevent basic SQL injection targeting IDs' do

      ISSInternship::Internship.create({title: 'New Project', position: 'new position',
                                       year: '2021', period: 'summer', job_description: 'good',
                                       reactionary: 'good', rating: 4})
      ISSInternship::Internship.create({title: 'Newer Project', position: 'new position',
                                       year: '2021', period: 'summer', job_description: 'good',
                                       reactionary: 'good', rating: 4})
      get 'api/v1/internships/2%20or%20id%3E0'

      # deliberately not reporting error -- don't give attacker information
      _(last_response.status).must_equal 404
      _(last_response.body['data']).must_be_nil 
    end
  end

  describe 'Creating New Internships' do
    before do
      @req_header = { 'CONTENT_TYPE' => 'application/json' }
      @intern_data = DATA[:internships][1]
    end
    
    it 'HAPPY: should be able to create new internships' do
      post "api/v1/internships", @intern_data.to_json, @req_header
      _(last_response.status).must_equal 201
      _(last_response.header['Location'].size).must_be :>, 0

      created = JSON.parse(last_response.body)['data']['attributes']
      intern = ISSInternship::Internship.first

      _(created['id']).must_equal intern.id
      _(created['title']).must_equal @intern_data['title']
      _(created['year']).must_equal @intern_data['year']
      _(created['period']).must_equal @intern_data['period']
      _(created['job_description']).must_equal @intern_data['job_description']
      _(created['salary']).must_equal @intern_data['salary']
      _(created['reactionary']).must_equal @intern_data['reactionary']
      _(created['recruit_source']).must_equal @intern_data['recruit_source']
      _(created['rating']).must_equal @intern_data['rating']
      _(created['iss_module']).must_equal @intern_data['iss_module']
    end

    it 'SECURITY: should not create documents with mass assignment' do
      bad_data = @intern_data.clone
      bad_data['created_at'] = '1900-01-01'
      post "api/v1/internships", bad_data.to_json, @req_header

      _(last_response.status).must_equal 400
      _(last_response.header['Location']).must_be_nil
    end
  end
end
