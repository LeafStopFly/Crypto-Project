# frozen_string_literal: true

# Policy to determine if account can view an intership/interview post
class AccountPolicy
  def initialize(requestor, account)
    @requestor = requestor
    @this_account = account
  end

  # everyone can view post
  def can_view?
    self_request?
  end

  def can_edit?
    self_request?
  end

  def can_delete?
    self_request?
  end

  def can_view_post_author?
    self_request?
  end

  def summary
    {
      can_view: can_view?,
      can_edit: can_edit?,
      can_delete: can_delete?,
      can_view_post_author: can_view_post_author?
    }
  end

  private

  def self_request?
    @requestor == @this_account
  end
end
