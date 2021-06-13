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

    def self.call(req_username:, inter_id:)
      account = Account.first(username: req_username)
      interview = Interview.first(id: inter_id)

      policy = InterviewPolicy.new(account, interview)
      raise ForbiddenError unless policy.can_edit?
    
      # TODO update will fail
      Interview.update(interview.to_h[:attributes])
      interview
    end
  end
end