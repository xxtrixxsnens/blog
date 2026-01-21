module Jekyll
  module LocalizedDateFilter
    GERMAN_MONTHS = {
      "January" => "Januar", "February" => "Februar", "March" => "März",
      "April" => "April", "May" => "Mai", "June" => "Juni",
      "July" => "Juli", "August" => "August", "September" => "September",
      "October" => "Oktober", "November" => "November", "December" => "Dezember"
    }

    def localize_date(input, format, full_locale = "en-US")
      date = time(input)
      # Extract the primary language (e.g., "de" from "de-DE")
      lang = full_locale.split('-').first.downcase

      # 1. Handle English Ordinal Suffixes
      if lang == "en" && format.include?("%-dth")
        day = date.strftime("%-d")
        suffix = case day
                 when "1", "21", "31" then "st"
                 when "2", "22" then "nd"
                 when "3", "23" then "rd"
                 else "th"
                 end
        format = format.gsub("%-dth", "#{day}#{suffix}")
      end

      # 2. Apply strftime
      formatted_date = date.strftime(format)

      # 3. Translate to German if prefix is "de"
      if lang == "de"
        GERMAN_MONTHS.each do |en, de|
          formatted_date.gsub!(en, de)
        end
      end

      formatted_date
    end
  end
end

Liquid::Template.register_filter(Jekyll::LocalizedDateFilter)
