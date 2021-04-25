# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:internships) do
      primary_key :id
      foreign_key :company_id, table: :companies

      String :title, null: false
      String :position, null:false
      String :year, null: false
      String :period, null: false
      String :job_description, null: false
      String :salary
      String :reactionary, null: false
      String :recruit_source
      Float :rating, null: false
      String :iss_module

      DateTime :created_at
      DateTime :updated_at
    end
  end
end