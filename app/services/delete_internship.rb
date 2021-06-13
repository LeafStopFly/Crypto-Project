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

    # ISSInternship::Account.where(id:1).first.update(email: "123")
    def self.call(req_username:, inter_id:)
      account = Account.first(username: req_username)
      internship = Internship.first(id: inter_id)

      policy = InternshipPolicy.new(account, internship)
      raise ForbiddenError unless policy.can_delete?

      account.remove_owned_internship(internship)
      internship
    end
  end
end