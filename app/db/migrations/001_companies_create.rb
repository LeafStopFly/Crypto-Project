# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:companies) do
      primary_key :id

      String :company_no
      String :name, unique: true, null: false
      String :address
      String :type

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
