require 'spec_helper'

describe 'Fetching URLs from a service' do
  before(:all) { @list = ArchiveLister.list('http://ofqual.gov.uk') }

  subject(:list) { @list }

  it { should be_an(Array) }

  describe 'The first item' do
    subject(:item) { list.first }

    it { should be_an(Addressable::URI) }
    its(:path) { should eql('/') }
  end
end