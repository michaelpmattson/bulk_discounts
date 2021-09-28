class PublicHolidaysService < ApiService
  BASE_URL     = 'https://date.nager.at/api/v1/Get'
  COUNTRY_CODE = 'US'

  def self.next_three
    service = PublicHolidaysService.new
    service.next_three
  end

  def next_three
    holidays[current_index..current_index+2]
  end
  
  private

  attr_reader :holidays

  def initialize
    @holidays ||= get_holidays
  end

  def get_holidays
    endpoint = "#{BASE_URL}/#{COUNTRY_CODE}/#{Time.now.year}"
    parsed = get_data(endpoint)
    parsed.map do |data|
      PublicHoliday.new(data)
    end
  end


  def current_date
    Time.new.strftime('%Y-%m-%d')
  end

  def current_index
    i = 0
    holiday = holidays[i]
    while holidays[i].date < current_date
      i += 1
    end
    i + 1
  end
end
