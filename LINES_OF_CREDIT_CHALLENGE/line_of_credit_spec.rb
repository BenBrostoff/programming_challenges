require_relative 'line_of_credit'

describe 'Line_of_Credit' do 
  let(:start) { Time.now }

  let(:loc_1) { Line_of_Credit.new({:apr => 35, :credit_limit => 1000, :origin => start}) }
  let(:loc_2) { Line_of_Credit.new({:apr => 35, :credit_limit => 1000, :origin => start}) }

  let(:invalid_limit) { "Invalid card - credit limit must be above 0." }
  let(:invalid_apr) { "Invalid card - APR must be above 0." } 
  let(:invalid_type) { "Invalid transaction - must be valid type." } 
  let(:invalid_amount) { "Invalid transaction - must enter a non-negative amount." } 
  let(:overdraw) { "Invalid transaction - credit limit exceeded." }
  let(:overpay) { "Invalid transaction - payment must not exceed balance." }
  
  before(:each) do 
    loc_1.transact("Draw", 500)
    loc_2.transact("Draw", 500, Time.now)
    loc_2.transact("Payment", 200, Chronic.parse("15 days from now"))
    loc_2.transact("Draw", 100, Chronic.parse("25 days from now"))
  end

  context "error validation" do 

    it "should raise an error in attempt of creation of an invalid LOC" do
      expect{ 
          Line_of_Credit.new({:apr => 10, :credit_limit => -1}) 
        }.to raise_error(ArgumentError, invalid_limit)
      expect{ 
          Line_of_Credit.new({:apr => -1, :credit_limit => 10}) 
        }.to raise_error(ArgumentError, invalid_apr)
    end  

    it "should raise an error for invalid transactions" do 
      expect{ loc_1.transact("Invalid", 10, Time.now) }.to raise_error(ArgumentError, invalid_type)
      expect{ loc_1.transact("Draw", -1, Time.now) }.to raise_error(ArgumentError, invalid_amount)
      expect{ loc_1.transact("Payment", -1, Time.now) }.to raise_error(ArgumentError, invalid_amount)
    end

    it "should raise an error if a transaction draws LOC beyond max" do
      expect{ loc_1.transact("Draw", 1_000_000) }.to raise_error(ArgumentError, overdraw)
    end

    it "should raise an error if a payment decreases the balance to below zero" do
      expect{ loc_1.transact("Payment", 1_000_000) }.to raise_error(ArgumentError, overpay)
    end

  end

  context "simulated transactions" do 

    it "should update outstanding and remaining credit limit when drawn" do
      expect(loc_1.current_outstanding).to eq(500)
      expect(loc_1.current_credit_limit).to eq(500)

      expect(loc_2.current_outstanding).to eq(400)
      expect(loc_2.current_credit_limit).to eq(600)   
    end

    it "should calculate interest in 30 day intervals based on principal outstanding over time" do
      expect(loc_1.total_payment).to eq(514.38)
      expect(loc_2.total_payment).to eq(411.99)
    end  

    it "should reset card attributes at the end of the 30 day period" do
      loc_1.month_reset
      loc_2.month_reset

      expect(loc_1.period_outstanding).to eq(500)
      expect(loc_1.period_credit_limit).to eq(500)
      expect(loc_1.origin.round(1)).to eq((start + loc_1.thirty_days).round(1))
      expect(loc_1.cutoff.round(1)).to eq((start + loc_1.thirty_days * 2).round(1))

      expect(loc_2.period_outstanding).to eq(400)
      expect(loc_2.period_credit_limit).to eq(600)
      expect(loc_2.origin.round(1)).to eq((start + loc_2.thirty_days).round(1))
      expect(loc_2.cutoff.round(1)).to eq((start + loc_2.thirty_days * 2).round(1))
    end
  end


end