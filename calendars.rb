#!/usr/local/bin/macruby
framework 'calendarstore'
CalCalendarStore.defaultCalendarStore.calendars.each do |calendar|
print "\n" + calendar.uid + " " + calendar.title
end
print "\n"
