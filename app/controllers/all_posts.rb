# frozen_string_literal: true

require 'roda'
require_relative './app'

module ISSInternship
  # Web controller for Internship API
  class Api < Roda
    # for homepage internships & interviews
    route('all_internships') do |routing|
      routing.get do
        internships =
          if routing.params == {}
            Internship.all
          else
            # GET /all_internships?iss_module=xx
            Internship.where(iss_module: routing.params['iss_module']).all
          end
        JSON.pretty_generate(data: internships)
      rescue StandardError
        routing.halt 404, { message: 'Could not find internships' }.to_json
      end
    end

    route('all_interviews') do |routing|
      routing.get do
        interviews =
          if routing.params == {}
            Interview.all
          else
            # GET /all_interviews?iss_module=xx
            Interview.where(iss_module: routing.params['iss_module']).all
          end
        JSON.pretty_generate(data: interviews)
      rescue StandardError
        routing.halt 404, { message: 'Could not find interviews' }.to_json
      end
    end
  end
end
