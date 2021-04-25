# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:interviews) do
      primary_key :id
      foreign_key :company_id, table: :companies

      String :position, null:false
      String :time, null: false
      String :interview_location, null: false
      Float :level, null: false
      String :recruit_source
      Float :rating, null: false
      String :result, null: false
      String :description, null: false
      String :waiting_result_time
      String :advice
      String :iss_module

      DateTime :created_at
      DateTime :updated_at
    end
  end
end