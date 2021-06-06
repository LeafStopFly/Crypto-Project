# frozen_string_literal: true

module ISSInternship
  # Service object to create a new project for an owner
  class CreateInterviewForCompany
    def self.call(company_id:, interview_data:)
      Company.first(id: company_id)
             .add_interview(interview_data)
    end
  end
end
