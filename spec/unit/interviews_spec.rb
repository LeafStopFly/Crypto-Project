# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Intership Handling' do
  before do
    wipe_database

    DATA[:accounts].each do |account|
      ISSInternship::Account.create(account)
    end
  end

  it 'HAPPY: should retrieve correct data from database' do
    interv_data = DATA[:interviews][1]
    owner = ISSInternship::Account.first

    new_interv = owner.add_owned_interview(interv_data)

    interv = ISSInternship::Interview.find(id: new_interv.id)
    _(interv.id).must_equal new_interv.id
    _(interv.position).must_equal new_interv.position
    _(interv.time).must_equal new_interv.time
    _(interv.interview_location).must_equal new_interv.interview_location
    _(interv.level).must_equal new_interv.level
    _(interv.recruit_source).must_equal new_interv.recruit_source
    _(interv.rating).must_equal new_interv.rating
    _(interv.result).must_equal new_interv.result
    _(interv.description).must_equal new_interv.description
    _(interv.waiting_result_time).must_equal new_interv.waiting_result_time
    _(interv.advice).must_equal new_interv.advice
    _(interv.iss_module).must_equal new_interv.iss_module
    _(interv.company_name).must_equal new_interv.company_name
    _(interv.non_anonymous).must_equal new_interv.non_anonymous
  end

  it 'SECURITY: should not use deterministic integers as ID' do
    interv_data = DATA[:interviews][1]
    owner = ISSInternship::Account.first
    new_interv = owner.add_owned_interview(interv_data)

    _(new_interv.id.is_a?(Numeric)).must_equal false
  end

  it 'SECURITY: should secure sensitive attributes' do
    interv_data = DATA[:interviews][1]
    owner = ISSInternship::Account.first
    new_interv = owner.add_owned_interview(interv_data)

    stored_interv = app.DB[:interviews].first

    _(stored_interv[:description_secure]).wont_equal new_interv.description
    _(stored_interv[:advice_secure]).wont_equal new_interv.advice
  end
end
