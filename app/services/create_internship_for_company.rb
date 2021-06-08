# frozen_string_literal: true

module ISSInternship
  # Service object to create a new internship for a company
  class CreateInternshipForCompany
    def self.call(company_id:, internship_data:)
      Company.first(id: company_id)
             .add_internship(internship_data)
    end
  end
end
