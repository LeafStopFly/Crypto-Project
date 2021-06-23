# frozen_string_literal: true

module ISSInternship
  # Edit owner's existing interview post
  class EditInterview
    # Error for someone is not owner
    class ForbiddenError < StandardError
      def message
        'You are not allowed to edit that interview'
      end
    end

    def self.call(auth:, new_interv:, inter_id:)
      interview = Interview.first(id: inter_id)

      policy = InterviewPolicy.new(auth[:account], interview, auth[:scope])
      raise ForbiddenError unless policy.can_edit?

      interview.update(new_interv.to_h)
      interview
    end
  end
end
