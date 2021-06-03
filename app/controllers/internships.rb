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
        # GET api/v1/internships/[internship_id]
        routing.get do
          internship = Internship.first(id: internship_id)
          internship ? internship.to_json : raise('Internship not found')
        rescue StandardError => e
          routing.halt 404, { message: e.message }.to_json
        end
      end

      # GET api/v1/internships
      routing.get do
        account = Account.first(username: @auth_account['username'])
        internships = account.internships
        JSON.pretty_generate(data: internships)
      rescue StandardError
        routing.halt 404, { message: 'Could not find internships' }.to_json
      end

      # POST api/v1/internships
      routing.post do
        new_data = JSON.parse(routing.body.read)
        new_intern = Internship.new(new_data)
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
