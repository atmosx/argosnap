require_relative '../../test_helper'

describe Argosnap do
  before do
    # @balance = Argosnap::Fetch.new.balance
    @balance = 4.0888
  end

  it "balance is not nil" do
    @balance.wont_be_nil
  end

  it "balance is a float" do
    @balance.must_be_kind_of Float
  end
end
