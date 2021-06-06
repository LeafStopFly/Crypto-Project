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
        account = Account.first(username: @auth_account['username'])
        interviews = account.interviews
        JSON.pretty_generate(data: interviews)
      rescue StandardError
        routing.halt 404, { message: 'Could not find interviews' }.to_json
      end

      # POST api/v1/interviews
      routing.post do
        new_data = JSON.parse(routing.body.read)
        new_interv = Interview.new(new_data)
        raise('Could not save interview') unless new_interv.save

        response.status = 201
        response['Location'] = "#{@interview_route}/#{new_interv.id}"
        { message: 'interview saved', data: new_interv }.to_json
      rescue Sequel::MassAssignmentRestriction
        routing.halt 400, { message: 'Illegal Request' }.to_json
      rescue StandardError => e
        routing.halt 500, { message: e.message }.to_json
      end
    end
  end
end
