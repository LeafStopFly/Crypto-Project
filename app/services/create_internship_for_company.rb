# frozen_string_literal: true

module ISSInternship
  # Service object to create a new project for an owner
  class CreateInternshipForCompany
    def self.call(company_id:, internship_data:)
      Company.first(id: company_id)
        .add_internship(internship_data)
    end
  end
end
