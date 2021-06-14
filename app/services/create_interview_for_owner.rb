# frozen_string_literal: true

module ISSInternship
  # Service object to create a new interview for an owner
  class CreateInterviewForOwner
    # Error for invalid account cannot add interview
    class ForbiddenError < StandardError
      def message
        'You are not allowed to add interview'
      end
    end

    def self.call(auth:, interview_data:)
      raise ForbiddenError unless auth[:scope].can_write?('interviews')

      # this interview data should be in db
      auth[:account].add_owned_interview(interview_data)
    end
  end
end
