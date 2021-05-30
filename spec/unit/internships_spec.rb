# frozen_string_literal: true

require_relative '../spec_helper'

describe 'Test Intership Handling' do
  before do
    wipe_database

    DATA[:companies].each do |company_data|
      ISSInternship::Company.create(company_data)
    end
  end

  it 'HAPPY: should retrieve correct data from database' do
    intern_data = DATA[:internships][1]
    comp = ISSInternship::Company.first
    new_intern = comp.add_internship(intern_data)

    intern = ISSInternship::Internship.find(id: new_intern.id)
    _(intern.id).must_equal new_intern.id
    _(intern.title).must_equal new_intern.title
    _(intern.year).must_equal new_intern.year
    _(intern.period).must_equal new_intern.period
    _(intern.job_description).must_equal new_intern.job_description
    _(intern.salary).must_equal new_intern.salary
    _(intern.reactionary).must_equal new_intern.reactionary
    _(intern.recruit_source).must_equal new_intern.recruit_source
    _(intern.rating).must_equal new_intern.rating
    _(intern.iss_module).must_equal new_intern.iss_module
  end

  it 'SECURITY: should not use deterministic integers as ID' do
    intern_data = DATA[:internships][1]
    comp = ISSInternship::Company.first
    new_intern = comp.add_internship(intern_data)

    _(new_intern.id.is_a?(Numeric)).must_equal false
  end

  it 'SECURITY: should secure sensitive attributes' do
    intern_data = DATA[:internships][1]
    comp = ISSInternship::Company.first
    new_intern = comp.add_internship(intern_data)
    stored_intern = app.DB[:internships].first

    _(stored_intern[:job_description_secure]).wont_equal new_intern.job_description
    _(stored_intern[:reactionary_secure]).wont_equal new_intern.reactionary
  end
end
