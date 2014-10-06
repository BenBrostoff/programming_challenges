require 'chronic'

class Line_of_Credit

  attr_accessor :apr, :credit_limit, :transactions,
                :period_outstanding, :current_outstanding, 
                :period_credit_limit, :current_credit_limit,
                :origin, :cutoff

  def initialize(card_properties)
    if !card_properties[:apr].is_a?(Integer || Float) ||
       !card_properties[:credit_limit].is_a?(Integer || Float)
      raise ArgumentError, "Invalid card - APR and credit limit must be in valid form." 
    end
    raise ArgumentError, "Invalid card - APR must be above 0." if card_properties[:apr] < 0
    raise ArgumentError, "Invalid card - credit limit must be above 0." if card_properties[:credit_limit] < 0

    @apr = card_properties.fetch(:apr, 15).to_f / 100.0 
    @period_credit_limit = @current_credit_limit = card_properties.fetch(:credit_limit, 1_000)
    @period_outstanding = @current_outstanding = 0
    @transactions = {}
    @origin, @cutoff = card_properties[:origin], card_properties[:origin] + thirty_days 
    @valid_types = ["Draw", "Payment"]
  end

  def transact(type, amount, time = Time.now) 
    raise ArgumentError, "Invalid transaction - must be valid type." if !@valid_types.include?(type)
    raise ArgumentError, "Invalid transaction - must enter a non-negative amount." if amount < 0
    raise ArgumentError, "Invalid transaction - credit limit exceeded." if amount > @current_credit_limit && type == "Draw"
    raise ArgumentError, "Invalid transaction - payment must not exceed balance." if amount > @current_outstanding && type == "Payment"
    
    amount = amount * -1 if type == "Payment"

    @current_outstanding += amount
    @current_credit_limit -= amount

    @transactions[time] = { :type => type, :amount => amount,
                            :outstanding => @current_outstanding,
                            :credit_limit => @current_credit_limit }
  end

  def period_convert(end_date, start_date, os, apr)
    days = ((end_date - start_date) / (24 * 60 ** 2)).round
    (days.to_f / 365.0 * os * apr).round(2)
  end

  def calc_interest
    interest, outstanding, last_date = 0, @period_outstanding, @origin
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

  def thirty_days
    30 * 24 * 60 ** 2
  end

  def month_reset
    @period_credit_limit = @current_credit_limit
    @period_outstanding = @current_outstanding
    @origin = @cutoff
    @cutoff = @origin + thirty_days
  end

end
