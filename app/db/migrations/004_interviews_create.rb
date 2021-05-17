# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:interviews) do
      uuid :id, primary_key: true
      foreign_key :company_id, table: :companies
      foreign_key :owner_id, :accounts

      String :position, null: false
      String :time, null: false
      String :interview_location, null: false
      String :level, null: false
      String :recruit_source
      Float :rating, null: false
      String :result, null: false
      String :description_secure, null: false
      String :waiting_result_time
      String :advice_secure
      String :iss_module

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
