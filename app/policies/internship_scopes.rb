# frozen_string_literal: true

module ISSInternship
  # Policy to determine if account can view a internship
  class InternshipPolicy
    # Scope of internship policies
    class AccountScope
      def initialize(current_account, target_account = nil)
        target_account ||= current_account
        @full_scope = all_internships(target_account)
        @current_account = current_account
        @target_account = target_account
      end

      def viewable
        @full_scope if @current_account == @target_account
      end

      private

      def all_internships(account)
        account.owned_internships
      end
    end
  end
end