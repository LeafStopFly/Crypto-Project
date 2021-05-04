it 'SECURITY: should not create project with mass assignment' 
    do bad_data = @proj_data.clone
    bad_data['created_at'] = '1900-01-01'
    post 'api/v1/companies', bad_data.to_json, @req_header
    
    _(last_response.status).must_equal 400
    _(last_response.header['Location']).must_be_nil 
end

it 'SECURITY: should prevent basic SQL injection to get index' do 
    get 'api/v1/companies/2%20or%20id%3D1'
   
    _(last_response.status).must_equal 404
    _(last_response.body['data']).must_be_nil 
end