require 'spec_helper'

module ArchiveLister
  describe WaybackFile do
    describe '.parse' do
      subject(:file) { WaybackFile.parse(File.read(content_filename('voa_wayback.html'))) }

      describe 'the URLs' do
        subject(:urls) { file.urls }

        it { should be_an(Array) }
        it { should have(866).urls }

        describe 'the first URL' do
          subject(:url) { urls.first }

          it         { should be_an(Addressable::URI) }
          its(:to_s) { should eql('http://www.voa.gov.uk:80/corporate') }
        end
      end
    end
  end
end