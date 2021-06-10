# frozen_string_literal: true

module ISSInternship
  # Policy to determine if account can view a interview
  class InterviewPolicy
    # Scope of interview policies
    class AccountScope
      def initialize(current_account, target_account = nil)
        target_account ||= current_account
        @full_scope = all_interviews(target_account)
        @current_account = current_account
        @target_account = target_account
      end

      def viewable
        @full_scope if @current_account == @target_account
      end

      private

      def all_interviews(account)
        account.owned_interviews
      end
    end
  end
end