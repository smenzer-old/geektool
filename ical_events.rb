#!/usr/local/bin/macruby
 
def colorize(text, color_code)
  "\e[0;#{color_code}m#{text}"
end
 
def black(text=""); colorize(text, 30); end
def red(text=""); colorize(text, 31); end
def green(text=""); colorize(text, 32); end
def yellow(text=""); colorize(text, 33); end
def blue(text=""); colorize(text, 34); end
def magenta(text=""); colorize(text, 35); end
def cyan(text=""); colorize(text, 36); end
def white(text=""); colorize(text, 37); end
 
def bold(&block)
  code = "\e[1m"
 
  if block_given?
    begin
      print code
      yield
    ensure
      print regular
    end
  else
    code
  end
end
 
def regular
  "\e[0m"
end
 
framework 'eventkit'
 
store = EKEventStore.alloc.initWithAccessToEntityTypes EKEntityTypeEvent | EKEntityTypeReminder

appnexus = store.calendarWithIdentifier:"86BDD79D-CB9A-4D51-84AD-E707F4276C2D"
googlepersonal = store.calendarWithIdentifier:"62E56BB7-6BD4-4BB7-867A-7EAF8C0D5AC9"

predicate = store.predicateForEventsWithStartDate NSDate.dateWithNaturalLanguageString('today at midnight'),
              endDate: NSDate.dateWithNaturalLanguageString('tomorrow at midnight'),
              calendars: [appnexus, googlepersonal]
 
date = NSDateFormatter.new
date.setDateStyle NSDateFormatterLongStyle
date.setTimeStyle NSDateFormatterNoStyle
 
time = NSDateFormatter.new
time.setDateFormat "hh:mm"
 
events = store.eventsMatchingPredicate(predicate)
 
OnlyDate = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit
 
require 'date'
 
class Time
  def midnight?
    [hour, min, sec, usec].all? { |val| val == 0 }
  end
end
 
class EKEvent
  def days
    calendar = NSCalendar.currentCalendar
 
    first = calendar.dateFromComponents(calendar.components OnlyDate, fromDate: self.startDate)
    last = calendar.dateFromComponents(calendar.components OnlyDate, fromDate: self.endDate)
 
    days = []
 
    next_day = NSDateComponents.new
    next_day.setDay 1
 
    date = first
 
    days << date
 
    while o = date.compare(last) and o == NSOrderedAscending
      date = calendar.dateByAddingComponents next_day, toDate: date, options: 0
      days << date
    end
 
    if not last.midnight? and not days.last == last
      days << last
    end
 
    days
  end
end
 
now = Time.now
 
table = Hash.new{|h,k| h[k] = [] }
 
events.each do |event|
  event.days.each do |day|
    table[day] << event
  end
end
 
# sort days
table = Hash[ table.sort_by{ |date, events| date } ]
 
table.each do |day, events|
 
  bold do
    puts date.stringFromDate(day)
  end
 
  # sort events
  events.sort_by(&:startDate).each do |event|
 
    start = event.startDate
    ends = event.endDate
 
	if now > ends
		next
	end

    print ' ' * 3

    current = false
    if now > start and now < ends
      current = true
      print bold
      if day.to_date == now.to_date
		print '✓'
      else
		print "\u2606" # 22c6
#          print regular
      end
	  print regular
    else
      print ' '
    end
 
    print ' '
 
    # puts [event.allDay?, start, day, ends ].inspect
 
	print red if current
    if event.allDay? or start.to_date != day.to_date && ends.to_date != day.to_date
      print "(all day)\t"
    else
      if start.to_date == day.to_date
        print time.stringFromDate(start)
      else
        print "  \u21c7  "
      end
 
      print ' - '
 
      if ends.to_date == day.to_date
        print time.stringFromDate(ends)
      else
        print "  \u21c9  "
      end
    end
 
    print "\t"

	print white
    print bold if current
	print "[#{event.location}] " if event.location and not event.location.empty?
    print event.title
    print regular
 
#    print " @ #{event.location}" if event.location and not event.location.empty?
    print "\n"
  end
 
  puts
end
