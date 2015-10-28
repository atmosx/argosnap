require_relative '../../test_helper'

describe Argosnap do
  before do
    @balance = Argosnap::Fetch.new.balance
    @threshold = Argosnap::Configuration.new.data[:threshold]
  end

  it 'balance is a float' do
    @balance.must_be_kind_of Float
  end

  it 'threshold is a float' do
    @threshold.must_be_kind_of (Fixnum || Float)
  end

end
