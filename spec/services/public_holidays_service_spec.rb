require 'rails_helper'
require 'timecop'

RSpec.describe PublicHolidaysService, type: :service do
  describe '.next_three' do
    before do
      Timecop.freeze(Time.local(2021, 9, 27))
    end

    after do
      Timecop.return
    end

    it 'returns next three holidays' do
      stub_request(:get, "https://date.nager.at/api/v1/Get/US/#{Time.now.year}").to_return(body: File.read(File.join('spec', 'fixtures', 'nager_date_public_holidays.json')))
      
      holidays = PublicHolidaysService.next_three
      expect(holidays.map(&:name)).to eq(["Veterans Day", "Thanksgiving Day", "Christmas Day"])
    end
  end
end
