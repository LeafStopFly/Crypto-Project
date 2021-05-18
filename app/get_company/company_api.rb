# frozen_string_literal: false

require 'http'
module ISSInternship
  module CompanyInf
  # Library for GCIS Web API
    class Api
      def company_data(company_no)
        Request.new.company(company_no).parse
      end

      # Sends out HTTP requests to GCIS
      class Request
        # GOV_PATH = 'https://data.gcis.nat.gov.tw/od/data/api/426D5542-5F05-43EB-83F9-F1300F14E1F1?$format=json&$filter=President_No%20eq%20'.freeze
        GOV_PATH = 'https://data.gcis.nat.gov.tw/od/data/api/5F64D864-61CB-4D0D-8AD9-492047CC1EA6?$format=json&$filter=Business_Accounting_NO%20eq%20'.freeze
        
        def company(company_no)
          get(GOV_PATH+company_no)
        end

        def get(url)
          http_response = HTTP.get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses from GCIS with success/error
      class Response < SimpleDelegator
        Unauthorized = Class.new(StandardError)
        NotFound = Class.new(StandardError)

        HTTP_ERROR = {
          401 => Unauthorized,
          404 => NotFound
        }.freeze

        def successful?
          HTTP_ERROR.keys.include?(code) ? false : true
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
