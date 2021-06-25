# frozen_string_literal: true

module ISSInternship
  # Delete owner's existing interview post
  class DeleteInterview
    # Error for someone is not owner
    class ForbiddenError < StandardError
      def message
        'You are not allowed to delete that interview'
      end
    end

    def self.call(auth:, inter_id:)
      interview = Interview.first(id: inter_id)

      policy = InterviewPolicy.new(auth[:account], interview, auth[:scope])
      raise ForbiddenError unless policy.can_delete?

      interview.destroy
      interview
    end
  end
end
