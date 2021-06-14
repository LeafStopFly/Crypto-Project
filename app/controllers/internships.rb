# frozen_string_literal: true

require 'roda'
require_relative './app'

module ISSInternship
  # Web controller for Internship API
  class Api < Roda
    # Not classified internships
    route('internships') do |routing|
      @internship_route = "#{@api_root}/internships"

      routing.on String do |internship_id|
        @req_internship = Internship.first(id: internship_id)

        # GET api/v1/internships/[internship_id]
        routing.get do
          internship = GetInternshipQuery.call(
            auth: @auth, internship: @req_internship
          )

          { data: internship }.to_json
        rescue GetInternshipQuery::ForbiddenError => e
          routing.halt 403, { message: e.message }.to_json
        rescue GetInternshipQuery::NotFoundError => e
          routing.halt 404, { message: e.message }.to_json
        rescue StandardError => e
          puts "FIND INTERNSHIP ERROR: #{e.inspect}"
          routing.halt 500, { message: 'API server error' }.to_json
        end

        # PUT api/v1/internships/[internship_id]
        routing.put do
          routing.halt(403, UNAUTH_MSG) unless @auth_account
          internship = EditInternship.call(
            auth: @auth,
            inter_id: internship_id
          )

          { message: "#{internship.title} edited.",
            data: internship }.to_json
        rescue DeleteInternship::ForbiddenError => e
          routing.halt 403, { message: e.message }.to_json
        rescue StandardError
          routing.halt 500, { message: 'API server error' }.to_json
        end

        # DELETE api/v1/internships/[internship_id]
        routing.delete do
          routing.halt(403, UNAUTH_MSG) unless @auth_account
          internship = DeleteInternship.call(
            auth: @auth,
            inter_id: internship_id
          )

          { message: "#{internship.title} deleted.",
            data: internship }.to_json
        rescue DeleteInternship::ForbiddenError => e
          routing.halt 403, { message: e.message }.to_json
        rescue StandardError
          routing.halt 500, { message: 'API server error' }.to_json
        end
      end

      # GET api/v1/internships
      routing.get do
        internships = InternshipPolicy::AccountScope.new(@auth_account).viewable
        JSON.pretty_generate(data: internships)
      rescue StandardError
        routing.halt 403, { message: 'Could not find internships' }.to_json
      end

      # POST api/v1/internships
      routing.post do
        routing.halt(403, UNAUTH_MSG) unless @auth_account
        new_data = JSON.parse(routing.body.read)
        new_intern = CreateInternshipForOwner.call(
          auth: @auth, internship_data: new_data
        )
        raise('Could not save internship') unless new_intern.save

        response.status = 201
        response['Location'] = "#{@internship_route}/#{new_intern.id}"
        { message: 'Internship saved', data: new_intern }.to_json
      rescue Sequel::MassAssignmentRestriction
        routing.halt 400, { message: 'Illegal Request' }.to_json
      rescue StandardError => e
        routing.halt 500, { message: e.message }.to_json
      end
    end
  end
end
