# frozen_string_literal: true

module ISSInternship
  # Add a collaborator to another owner's existing project
  class AddAccountToCompany
    def self.call(username:, company_no:)
      intern = Account.first(username: username)
      company = Company.first(company_no: company_no)
  
      intern.add_company
      intern
    end
  end
end