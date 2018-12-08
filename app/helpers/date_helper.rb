# frozen_string_literal: true

module DateHelper
  def decorate_date(date)
    date.strftime("%A, %b %d, %Y, %H:%M:%S, %Z")
  end
end
