# frozen_string_literal: true

Sequel.seed(:development) do
  def run
    puts 'Seeding accounts, companies, internships, interviews'
    create_accounts
    create_owned_companies
    create_internships
    create_interviews
  end
end
  
  equire 'yaml'
  DIR = File.dirname(__FILE__)
  ACCOUNTS_INFO = YAML.load_file("#{DIR}/accounts_seed.yml")
  OWNER_INFO = YAML.load_file("#{DIR}/owners_companies.yml")
  COMP_INFO = YAML.load_file("#{DIR}/companies_seeds")
  INTERNSHIP_INFO = YAML.load_file("#{DIR}/internship_seeds.yml")
  INTERVIEW_INFO = YAML.load_file("#{DIR}/interview_seeds.yml")
  
  def create_accounts
    ACCOUNTS_INFO.each do |account_info|
      ISSInternship::Account.create(account_info)
    end
  end
  
  def create_owned_companies
    OWNER_INFO.each do |owner|
      account = ISSInternship::Account.first(username: owner['username'])
      owner['comp_name'].each do |comp_name|
        comp_data = COMP_INFO.find { |comp| comp['name'] == comp_name }
        ISSInternship::CreateCompanyForOwner.call(
          owner_id: account.id, company_data: comp_data
        )
      end
    end
  end
  
  def create_internships
    intern_info_each = INTERNSHIP_INFO.each
    companies_cycle = ISSInternship::Company.all.cycle
    loop do
      intern_info = intern_info_each.next
      company = companies_cycle.next
      ISSInternship::CreateInternshipForCompany.call(
        company_id: company.id, internship_data: intern_info
      )
    end
  end

  def create_interviews
    interv_info_each = INTERVIEW_INFO.each
    companies_cycle = ISSInternship::Company.all.cycle
    loop do
      interv_info = interv_info_each.next
      company = companies_cycle.next
      ISSInternship::CreateInterviewForCompany.call(
        company_id: company.id, interview_data: interv_info
      )
    end
  end
  
end