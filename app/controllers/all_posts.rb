# frozen_string_literal: true

require 'roda'
require_relative './app'

module ISSInternship
  # Web controller for Internship API
  class Api < Roda
    # for homepage internships & interviews
    route('all_internships') do |routing|
      routing.get do
        if routing.params == {}
          internships = Internship.all
          JSON.pretty_generate(data: internships)
        else
          # GET /all_internships?iss_module=xx
          internships = Internship.where(iss_module: routing.params['iss_module']).all
          JSON.pretty_generate(data: internships)
        end
      rescue StandardError
        routing.halt 404, { message: 'Could not find internships' }.to_json
      end
    end

    route('all_interviews') do |routing|
      routing.get do
        if routing.params == {}
          interviews = Interview.all
          JSON.pretty_generate(data: interviews)
        else
          # GET /all_interviews?iss_module=xx
          interviews = Interview.where(iss_module: routing.params['iss_module']).all
          JSON.pretty_generate(data: interviews)
        end
      rescue StandardError
        routing.halt 404, { message: 'Could not find interviews' }.to_json
      end
    end
  end
end
