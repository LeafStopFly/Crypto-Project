# frozen_string_literal: false

require_relative '../models/companies'
require_relative 'company_api'
module ISSInternship
  module CompanyInf
    # Data Mapper: GCIS company -> Company entity
    class CompanyMapper
      def initialize(gateway_class = CompanyInf::Api)
        @gateway_class = gateway_class
        @gateway = @gateway_class.new
      end

      def find(company_no)
        data = @gateway.company_data(company_no)
        build_entity(data)
      end

      def build_entity(company)
        if company != nil
          DataMapper.new(company).build_entity
        end
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(comp_detail)
          @data = comp_detail[0]
        end

        # ISSInternship::Company.create(DATA[:companies][0]).save
        def build_entity
          ISSInternship::Company.create(
            company_no: company_no,
            name: name,
            address: address
          )
        end

        def company_no
          @data['Business_Accounting_NO']
        end

        def name
          @data['Company_Name']
        end

        def address
          @data['Company_Location']
        end
      end
    end
  end
end
