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
          @req_interview = Interview.first(id: interview_id)

          # interview = GetInterviewQuery.call(
          #   auth: @auth, interview: @req_interview
          # )

          { data: @req_interview }.to_json
        rescue GetInterviewQuery::ForbiddenError => e
          routing.halt 403, { message: e.message }.to_json
        rescue GetInterviewQuery::NotFoundError => e
          routing.halt 404, { message: e.message }.to_json
        rescue StandardError => e
          puts "FIND INTERVIEW ERROR: #{e.inspect}"
          routing.halt 500, { message: 'API server error' }.to_json
        end

        # POST api/v1/interviews/[interview_id]
        routing.post do
          routing.halt(403, UNAUTH_MSG) unless @auth_account

          new_data = JSON.parse(routing.body.read)
          interview = EditInterview.call(
            auth: @auth,
            new_interv: new_data,
            inter_id: interview_id
          )

          { message: "#{interview.position} edited.",
            data: interview }.to_json
        rescue EditInterview::ForbiddenError => e
          routing.halt 403, { message: e.message }.to_json
        rescue StandardError
          routing.halt 500, { message: 'API server error' }.to_json
        end

        # DELETE api/v1/interviews/[interview_id]
        routing.delete do
          # req_data = JSON.parse(routing.body.read)
          routing.halt(403, UNAUTH_MSG) unless @auth_account
          interview = DeleteInterview.call(
            auth: @auth,
            inter_id: interview_id
          )

          { message: "#{interview.position} deleted.",
            data: interview }.to_json
        rescue DeleteInterview::ForbiddenError => e
          routing.halt 403, { message: e.message }.to_json
        rescue StandardError
          routing.halt 500, { message: 'API server error' }.to_json
        end
      end

      # GET api/v1/interviews
      routing.get do
        interviews = InterviewPolicy::AccountScope.new(@auth_account).viewable
        JSON.pretty_generate(data: interviews)
      rescue StandardError
        routing.halt 403, { message: 'Could not find interviews' }.to_json
      end

      # POST api/v1/interviews
      routing.post do
        routing.halt(403, UNAUTH_MSG) unless @auth_account
        new_data = JSON.parse(routing.body.read)
        new_interv = CreateInterviewForOwner.call(
          auth: @auth, interview_data: new_data
        )
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
