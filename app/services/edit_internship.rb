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

    def self.call(req_username:, inter_id:)
      account = Account.first(username: req_username)
      internship = Internship.first(id: inter_id)

      policy = InternshipPolicy.new(account, internship)
      raise ForbiddenError unless policy.can_edit?
    
      # TODO update will fail
      Internship.update(internship.to_h[:attributes])
      internship
    end
  end
end