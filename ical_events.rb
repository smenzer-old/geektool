#!/usr/local/bin/macruby
framework 'calendarstore'

# This required MacRuby to be installed.
# A package installer for 10.6+ is available at http://www.macruby.org/

# Period is the number of days (including today) to include in the list.
# The default is three days.
before = (0 * 3600 * 24)
after = (1 * 3600 * 24)

range = (Time.local(Time.now.year, Time.now.mon, Time.now.day) - before)..(Time.local(Time.now.year, Time.now.mon, Time.now.day) + after)

# add calendars here
appnexus = CalCalendarStore.defaultCalendarStore.calendarWithUID("688A560E-6CEC-450E-BC9A-48C3A8FF4D0E")
googlepersonal = CalCalendarStore.defaultCalendarStore.calendarWithUID("E972398A-8357-49B9-B28A-6B87D8572DA0")

# determine id's and names of calendars in the system
#CalCalendarStore.defaultCalendarStore.calendars.each do |event|
#    print event.uid + " " + event.title + "\n";
#end
#exit;

# update calendars array on this line
predicate = CalCalendarStore.eventPredicateWithStartDate(NSDate.dateWithString(range.begin.to_s), endDate:NSDate.dateWithString(range.end.to_s), calendars:[appnexus, googlepersonal])
day_cache = nil

CalCalendarStore.defaultCalendarStore.eventsWithPredicate(predicate).each do |event|
  started_at = Time.at(event.startDate.timeIntervalSince1970)
  ends_at = Time.at(event.endDate.timeIntervalSince1970)

#Display DAY MONTH and DATE then each event
  print "\n" if day_cache != nil && started_at.day != day_cache

#  print "TODAY'S AGENDA\n" if started_at.day != day_cache
  print started_at.strftime("- %A %B %d").upcase + "\n" if started_at.day != day_cache

#Display a check if event has ended
#  print " ✓" if ends_at < Time.now 

#Display a star if event is current
  print " ☆" if started_at < Time.now && ends_at > Time.now
  
#Display ∞ if event is all day
  print " ∞" if event.isAllDay && (started_at > Time.now || ends_at < Time.now)

#Display event details
  print "\t" + (event.isAllDay ? "" : started_at.strftime("%I:%M %p") + "   ") if ends_at >= Time.now 
  print event.title if ends_at >= Time.now 
  print "\n\t\t\t@ " + event.location if ends_at >= Time.now && event.location != nil && event.location != ''
  print "\n" if ends_at >= Time.now 
  day_cache = started_at.day
end
