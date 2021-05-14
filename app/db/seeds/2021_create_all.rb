# frozen_string_literal: true

Sequel.seed(:development) do
  def run
    puts 'Seeding accounts, companies, internships, interviews'
    create_accounts
    # create_companies
    create_owned_internships
    create_owned_interviews
  end
end

require 'yaml'
DIR = File.dirname(__FILE__)
ACCOUNTS_INFO = YAML.load_file("#{DIR}/accounts_seed.yml")
# OWNER_INFO = YAML.load_file("#{DIR}/owners_companies.yml")
OWNER_INFO1 = YAML.load_file("#{DIR}/owners_internships.yml")
OWNER_INFO2 = YAML.load_file("#{DIR}/owners_interviews.yml")
COMP_INFO = YAML.load_file("#{DIR}/companies_seeds")
INTERNSHIP_INFO = YAML.load_file("#{DIR}/internship_seeds.yml")
INTERVIEW_INFO = YAML.load_file("#{DIR}/interview_seeds.yml")

def create_accounts
  ACCOUNTS_INFO.each do |account_info|
    ISSInternship::Account.create(account_info)
  end
end

def create_owned_internships
  OWNER_INFO1.each do |owner|
    account = ISSInternship::Account.first(username: owner['username'])
    owner['intern_name'].each do |intern_name|
      intern_data = INTERNSHIP_INFO.find { |intern| intern['name'] == intern_name }
      ISSInternship::CreateInternshipForOwner.call(
        owner_id: account.id, internship_data: intern_data
      )
    end
  end
end

def create_owned_interviews
  OWNER_INFO2.each do |owner|
    account = ISSInternship::Account.first(username: owner['username'])
    owner['interv_name'].each do |interv_name|
      interv_data = INTERVIEW_INFO.find { |interv| interv['name'] == interv_name }
      ISSInternship::CreateInterviewForOwner.call(
        owner_id: account.id, interview_data: interv_data
      )
    end
  end
end

# def create_internships
#   intern_info_each = INTERNSHIP_INFO.each
#   companies_cycle = ISSInternship::Company.all.cycle
#   loop do
#     intern_info = intern_info_each.next
#     company = companies_cycle.next
#     ISSInternship::CreateInternshipForCompany.call(
#       company_id: company.id, internship_data: intern_info
#     )
#   end
# end

# def create_interviews
#   interv_info_each = INTERVIEW_INFO.each
#   companies_cycle = ISSInternship::Company.all.cycle
#   loop do
#     interv_info = interv_info_each.next
#     company = companies_cycle.next
#     ISSInternship::CreateInterviewForCompany.call(
#       company_id: company.id, interview_data: interv_info
#     )
#   end
# end

# def create_companies
#   comp_info_each = COMP_INFO.each
#   companies_cycle = ISSInternship::Company.all.cycle
#   loop do
#     interv_info = interv_info_each.next
#     company = companies_cycle.next
#     ISSInternship::CreateInterviewForCompany.call(
#       company_id: company.id, interview_data: interv_info
#     )
#   end
# end
