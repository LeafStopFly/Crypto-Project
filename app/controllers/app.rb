# frozen_string_literal: true

require 'roda'
require 'json'
require_relative './helpers'

module ISSInternship
  # Web controller for Internship API
  class Api < Roda
    plugin :halt
    plugin :multi_route
    plugin :request_headers

    include SecureRequestHelpers

    route do |routing|
      response['Content-Type'] = 'application/json'

      secure_request?(routing) ||
        routing.halt(403, { message: 'TLS/SSL Required' }.to_json)

      routing.root do
        response.status = 200
        { message: 'ISS InternshipAPI up at /api/v1' }.to_json
      end

      routing.on 'api' do
        routing.on 'v1' do
          @api_root = 'api/v1'
          routing.multi_route
        end
      end
    end
  end
end
