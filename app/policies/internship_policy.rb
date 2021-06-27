# frozen_string_literal: true

module ISSInternship
  # Policy to determine if an account can view a particular internship
  class InternshipPolicy
    def initialize(account, internship, auth_scope = nil)
      @account = account
      @internship = internship
      @auth_scope = auth_scope
    end

    # duplication is ok!
    def can_edit?
      can_write? && account_is_owner?
    end

    def can_delete?
      can_write? && account_is_owner?
    end

    def summary
      {
        can_edit: can_edit?,
        can_delete: can_delete?
      }
    end

    private

    def can_write?
      @auth_scope ? @auth_scope.can_write?('internships') : false
    end

    def account_is_owner?
      @internship.owner == @account
    end
  end
end
