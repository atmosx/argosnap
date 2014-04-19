require_relative '../../test_helper'

describe Argosnap do
  it "must be defined" do
    Argosnap::VERSION.wont_be_nil
  end
end
