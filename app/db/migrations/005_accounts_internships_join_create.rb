# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_join_table(owned_id: :accounts, internships_id: {table: :internships, type: :uuid})
  end
end
