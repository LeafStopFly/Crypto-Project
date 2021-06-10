# frozen_string_literal: true

require 'roda'
require_relative './app'

module ISSInternship
  # Web controller for Internship API
  class Api < Roda
    # for homepage internships & interviews
    route('all_internships') do |routing|
      routing.get do
        internships = Internship.all
        JSON.pretty_generate(data: internships)
      rescue StandardError
        routing.halt 404, { message: 'Could not find internships' }.to_json
      end
    end

    route('all_interviews') do |routing|
      routing.get do
        interviews = Interview.all
        JSON.pretty_generate(data: interviews)
      rescue StandardError
        routing.halt 404, { message: 'Could not find interviews' }.to_json
      end
    end
  end
end