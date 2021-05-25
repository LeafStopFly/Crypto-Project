# frozen_string_literal: true

require 'roda'
require_relative './app'

module ISSInternship
  # Web controller for Internship API
  class Api < Roda
    # Not classified interviews
    route('interviews') do |routing|
      @interview_route = "#{@api_root}/interviews"

      routing.on String do |interview_id|
        # GET api/v1/interviews/[interview_id]
        routing.get do
          interview = Interview.first(id: interview_id)
          interview ? interview.to_json : raise('Interview not found')
        rescue StandardError => e
          routing.halt 404, { message: e.message }.to_json
        end
      end
  
      # GET api/v1/interviews
      routing.get do
        interviews = Interview.all.map do |each_intern|
          JSON.parse(each_intern.simplify_to_json)
        end
        JSON.pretty_generate(interviews)
      rescue StandardError
        routing.halt 404, { message: 'Could not find interviews' }.to_json
      end
    end
  end
end
