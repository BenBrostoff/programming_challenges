require_relative 'line_of_credit'

describe 'Line_of_Credit' do 

  let(:loc_1) {Line_of_Credit.new(35, 1000)}
  let(:loc_2) {Line_of_Credit.new(35, 1000)}
  
  before(:each) do 
    loc_1.transact("Draw", 500)
    loc_2.transact("Draw", 500, Time.now)
    loc_2.transact("Payment", 200, Chronic.parse("15 days from now"))
    loc_2.transact("Draw", 100, Chronic.parse("25 days from now"))
  end

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


end