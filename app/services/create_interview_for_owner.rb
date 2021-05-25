# frozen_string_literal: true

module ISSInternship
  # Service object to create a new project for an owner
  class CreateInterviewForOwner
    def self.call(owner_id:, interview_data:)
      # this interview data should be in db
      Account.find(id: owner_id)
        .add_owned_interview(interview_data)
    end
  end
end