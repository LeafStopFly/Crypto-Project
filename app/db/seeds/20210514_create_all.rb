# frozen_string_literal: true

Sequel.seed(:development) do
  def run
    puts 'Seeding accounts, companies, internships, interviews'
    create_accounts
    create_companies
    # add_interns
    # company_internships
    # company_interviews
    create_owned_internships
    create_owned_interviews
  end
end

require 'yaml'
DIR = File.dirname(__FILE__)
ACCOUNTS_INFO = YAML.load_file("#{DIR}/accounts_seeds.yml")
# INTERN_INFO = YAML.load_file("#{DIR}/accounts_companies.yml")
OWNER_INFO1 = YAML.load_file("#{DIR}/owners_internships.yml")
OWNER_INFO2 = YAML.load_file("#{DIR}/owners_interviews.yml")
COMP_INFO = YAML.load_file("#{DIR}/companies_seeds.yml")
INTERNSHIP_INFO = YAML.load_file("#{DIR}/internship_seeds.yml")
INTERVIEW_INFO = YAML.load_file("#{DIR}/interview_seeds.yml")
# COMP_INTERNSHIP = YAML.load_file("#{DIR}/company_internships.yml")
# COMP_INTERVIEW = YAML.load_file("#{DIR}/company_interviews.yml")

def create_accounts
  ACCOUNTS_INFO.each do |account_info|
    ISSInternship::Account.create(account_info)
  end
end

def create_companies
  COMP_INFO.each do |comp_info|
    ISSInternship::Company.create(comp_info)
  end
end

def create_owned_internships
  OWNER_INFO1.each do |owner|
    account = ISSInternship::Account.first(username: owner['username'])
    owner['intern_name'].each do |intern_name|
      intern_data = INTERNSHIP_INFO.find { |intern| intern['title'] == intern_name }
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
      interv_data = INTERVIEW_INFO.find { |interv| interv['position'] == interv_name }
      ISSInternship::CreateInterviewForOwner.call(
        owner_id: account.id, interview_data: interv_data
      )
    end
  end
end

# def add_interns
#   INTERN_INFO.each do |intern|
#     intern['company_no'].each do |comp_no|
#       ISSInternship::AddAccountToCompany.call(
#         username: intern['username'], company_no: comp_no
#       )
#     end
#   end
# end

# def company_internships
#   COMP_INTERNSHIP.each do |relation|
#     company = ISSInternship::Company.first(company_no: relation['company_no'])
#     relation['intern_title'].each do |title|
#       intern_data = INTERNSHIP_INFO.find { |intern| intern['title'] == title }
#       ISSInternship::CreateInternshipForCompany.call(
#         company_id: company.id, internship_data: intern_data
#       )
#     end
#   end
# end

# def company_interviews
#   COMP_INTERVIEW.each do |relation|
#     company = ISSInternship::Company.first(company_no: relation['company_no'])
#     relation['interv_name'].each do |name|
#       interv_data = INTERVIEW_INFO.find { |interv| interv['position'] == name }
#       ISSInternship::CreateInterviewForCompany.call(
#         company_id: company.id, interview_data: interv_data
#       )
#     end
#   end
# end
