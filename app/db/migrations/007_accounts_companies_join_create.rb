# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_join_table(account_id: :accounts, company_id: :companies)
  end
end