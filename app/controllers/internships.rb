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
        internships = Internship.all.map do |each_intern|
          JSON.parse(each_intern.simplify_to_json)
        end
        JSON.pretty_generate(internships)
      rescue StandardError
        routing.halt 404, { message: 'Could not find internships' }.to_json
      end
    end
  end
end
