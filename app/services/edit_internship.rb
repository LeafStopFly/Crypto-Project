# frozen_string_literal: true

module ISSInternship
  # Edit owner's existing internship post
  class EditInternship
    # Error for someone is not owner
    class ForbiddenError < StandardError
      def message
        'You are not allowed to edit that internship'
      end
    end

    def self.call(auth:, new_intern:, inter_id:)
      internship = Internship.first(id: inter_id)

      policy = InternshipPolicy.new(auth[:account], internship, auth[:scope])
      raise ForbiddenError unless policy.can_edit?

      internship.update(new_intern.to_h)
      internship
    end
  end
end
