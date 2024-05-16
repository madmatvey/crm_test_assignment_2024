# frozen_string_literal: true

module Companies
  class Finder
    include Interactor

    delegate :params, to: :context

    def call
      companies = Company.all
      companies = minimum_deal_amount_filter(companies)
      companies = name_filter(companies)
      companies = industry_filter(companies)
      # If I had more time, I would move Industry to a separate model, belongs_to Company
      # (or with polymorphic relation if Industry can be not only Companies,
      # but for example Vendors and so on),
      # make a separate endpoint to get the list of industries on the frontend
      # and redo the filter to search for industry matches by the ID of the related entity;

      companies = min_employee_filter(companies)

      context.companies = companies
    end

    private

    def name
      params[:name]
    end

    def industry
      params[:industry]
    end

    def min_employee
      params[:min_employee]
    end

    def minimum_deal_amount
      params[:minimum_deal_amount]
    end

    def minimum_deal_amount_filter(companies) # rubocop:disable Metrics/MethodLength
      if minimum_deal_amount.present?
        context.fail!(message: 'Minimum deal amount should be an integer') unless numeric?(minimum_deal_amount)

        sql = <<~SQL
          select
            companies.*
          from companies
          left join deals on deals.company_id=companies.id
          group by companies.id
          having COALESCE(sum(deals.amount),0) >= #{minimum_deal_amount}
        SQL
        companies.select('*').from("(#{sql}) AS companies")
      else
        companies
      end
    end

    def name_filter(companies)
      if name.present?
        companies.where('LOWER(name) LIKE LOWER(?)', "%#{name}%")
      else
        companies
      end
    end

    def industry_filter(companies)
      if industry.present?
        companies.where('LOWER(industry) LIKE LOWER(?)', "%#{industry}%")
      else
        companies
      end
    end

    def min_employee_filter(companies)
      if min_employee.present?
        context.fail!(message: 'Minimum employee count should be an integer') unless numeric?(min_employee)

        companies.where('employee_count >= ?', min_employee)
      else
        companies
      end
    end

    # If I had more time, I would add some kind of service-wide library for input validation
    # like https://github.com/dry-rb/dry-validation
    def numeric?(string)
      string.to_i.to_s == string || string.to_f.to_s == string
    end
  end
end
