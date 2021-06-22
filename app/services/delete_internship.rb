# frozen_string_literal: true

module ISSInternship
  # Delete owner's existing internship post
  class DeleteInternship
    # Error for someone is not owner
    class ForbiddenError < StandardError
      def message
        'You are not allowed to delete that internship'
      end
    end

    def self.call(auth:, inter_id:)
      internship = Internship.first(id: inter_id)

      policy = InternshipPolicy.new(auth[:account], internship, auth[:scope])
      raise ForbiddenError unless policy.can_delete?

      # auth[:account].remove_owned_internship(internship)
      internship.destroy
      internship
    end
  end
end
