class PublicHoliday
  attr_reader :date,
              :local_name,
              :name,
              :country_code,
              :fixed,
              :global,
              :counties,
              :launch_year,
              :type

  def initialize(data)
    @date         = data[:date]
    @local_name   = data[:localName]
    @name         = data[:name]
    @country_code = data[:countryCode]
    @fixed        = data[:fixed]
    @global       = data[:global]
    @counties     = data[:counties]
    @launch_year  = data[:launchYear]
    @type         = data[:type]
  end
end
