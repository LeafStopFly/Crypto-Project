# frozen_string_literal: true

module ISSInternship
  # View an existing interview
  class GetInterviewQuery
    # Error for someone is not allowed to access
    class ForbiddenError < StandardError
      def message
        'You are not allowed to access that interview'
      end
    end

    # Error for cannot find a interview
    class NotFoundError < StandardError
      def message
        'We could not find that interview'
      end
    end

    def self.call(account:, interview:)
      raise NotFoundError unless interview

      policy = InterviewPolicy.new(account, interview)
    #   raise ForbiddenError unless policy.can_view?

      interview.full_details.merge(policies: policy.summary)
    end
  end
end