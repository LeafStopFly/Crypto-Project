# frozen_string_literal: true

module ISSInternship
  # View an existing internship
  class GetInternshipQuery
    # Error for someone is not allowed to access
    class ForbiddenError < StandardError
      def message
        'You are not allowed to access that internship'
      end
    end

    # Error for cannot find a internship
    class NotFoundError < StandardError
      def message
        'We could not find that internship'
      end
    end

    def self.call(auth:, internship:)
      raise NotFoundError unless internship

      policy = InternshipPolicy.new(auth[:account], internship, auth[:scope])
      # raise ForbiddenError unless policy.can_view?

      internship.full_details.merge(policies: policy.summary)
    end
  end
end