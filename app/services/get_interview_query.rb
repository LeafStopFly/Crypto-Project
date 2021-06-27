# frozen_string_literal: true

module ISSInternship
  # View an existing interview
  class GetInterviewQuery
    # Error for cannot find a interview
    class NotFoundError < StandardError
      def message
        'We could not find that interview'
      end
    end

    def self.call(auth:, interview:)
      raise NotFoundError unless interview
      
      if auth.nil?
        interview
      else
        policy = InterviewPolicy.new(auth[:account], interview, auth[:scope])
        # raise ForbiddenError unless policy.can_view?

        interview.full_details.merge(policies: policy.summary)
      end
    end
  end
end
