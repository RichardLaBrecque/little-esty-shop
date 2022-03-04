class HolidayService
  def self.conn
    url = "https://date.nager.at/swagger/index.html"
    Faraday.new(url)
  end

  def self.search_holidays
    response = conn.get("https://date.nager.at/api/v2/NextPublicHolidays/US")
    JSON.parse(response.body, symbolize_names: true)
  end
end
