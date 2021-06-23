# frozen_string_literal: true

module ISSInternship
  # Policy to determine if an account can view a particular internship
  class InterviewPolicy
    def initialize(account, interview, auth_scope = nil)
      @account = account
      @interview = interview
      @auth_scope = auth_scope
    end

    # everyone can view
    #   def can_view?
    #     true
    #   end

    # duplication is ok!
    def can_edit?
      can_write? && account_is_owner?
    end

    def can_delete?
      can_write? && account_is_owner?
    end

    def can_view_post_author?
      can_read? && (account_is_owner? || interview_is_non_anonymous?)
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
      @auth_scope ? @auth_scope.can_read?('interviews') : false
    end

    def can_write?
      @auth_scope ? @auth_scope.can_write?('interviews') : false
    end

    def account_is_owner?
      @interview.owner == @account
    end

    def interview_is_non_anonymous?
      @interview.non_anonymous
    end
  end
end
