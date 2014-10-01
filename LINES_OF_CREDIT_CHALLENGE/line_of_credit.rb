require 'chronic'

class Line_of_Credit

  attr_accessor :apr, :credit_limit, 
                :transactions, :period_outstanding, :origin,
                :current_outstanding,
                :current_credit_limit, :cutoff

  def initialize(apr, credit_limit)
    @apr = apr.to_f / 100.0 
    @period_credit_limit, @current_credit_limit = credit_limit, credit_limit
    @transactions = {}
    @period_outstanding, @current_outstanding = 0, 0 
    @origin = Time.now
    @cutoff = Chronic.parse("30 days from now")
  end

  def transact(type, amount, time = Time.now) #for testing purposes
    amount = amount * -1 if type == "Payment"

    @current_outstanding += amount
    @current_credit_limit -= amount
    @transactions[time] = { :type => type, :amount => amount,
                                :outstanding => @current_outstanding,
                                :credit_limit => @current_credit_limit }
  end

  def period_convert(end_date, start_date, os, apr)
    days = ((end_date - start_date) / (24 * 60 * 60)).round
    (days.to_f / 365.0 * os * apr).round(2)
  end

  def calc_interest
    interest, outstanding, last_date = 0, @period_outstanding, origin
    @transactions.each do |key, value|
      if key < @cutoff
        interest += period_convert(key, last_date, outstanding, @apr)
    
        outstanding = value[:outstanding]
        last_date = key
      end
    end
    
    return interest += period_convert(@cutoff, last_date, outstanding, @apr)
  end

  def total_payment
    @current_outstanding + calc_interest
  end

end

