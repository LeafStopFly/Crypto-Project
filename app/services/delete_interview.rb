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

    # ISSInterview::Account.where(id:1).first.update(email: "123")
    def self.call(req_username:, inter_id:)
      account = Account.first(username: req_username)
      interview = Interview.first(id: inter_id)

      policy = InterviewPolicy.new(account, interview)
      raise ForbiddenError unless policy.can_delete?

      account.remove_owned_interview(interview)
      interview
    end
  end
end