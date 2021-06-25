# frozen_string_literal: true

module ISSInternship
  # Add a collaborator to another owner's existing project
  class SearchCompany
    def self.call(input)
      db_company = company_in_database(input)

      if db_company
        db_company
      else
        company_in_api(input)
      end
    end

    # Support methods

    def self.company_in_api(input)
      ISSInternship::CompanyInf::CompanyMapper.new.find(input)
    end

    def self.company_in_database(input)
      Company.first(company_no: input)
    end
  end
end
