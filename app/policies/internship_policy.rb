# frozen_string_literal: true

module ISSInternship
  # Policy to determine if an account can view a particular internship
  class InternshipPolicy
    def initialize(account, internship, auth_scope = nil)
      @account = account
      @internship = internship
      @auth_scope = auth_scope
    end

    # everyone can view
    # def can_view?
    #   true
    # end

    # duplication is ok!
    def can_edit?
      can_write? && account_is_owner?
    end

    def can_delete?
      can_write? && account_is_owner?
    end

    def can_view_post_author?
      can_read? && (account_is_owner? || internship_is_non_anonymous?)
    end

    def summary
      {
        # can_view: can_view?,
        can_edit: can_edit?,
        can_delete: can_delete?,
        can_view_post_author: can_view_post_author?
      }
    end

    private

    def can_read?
      @auth_scope ? @auth_scope.can_read?('internships') : false
    end

    def can_write?
      @auth_scope ? @auth_scope.can_write?('internships') : false
    end

    def account_is_owner?
      @internship.owner == @account
    end

    def internship_is_non_anonymous?
      @internship.non_anonymous
    end
  end
end
