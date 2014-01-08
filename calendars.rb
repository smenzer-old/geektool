#!/usr/local/bin/macruby
framework 'eventkit'

store = EKEventStore.alloc.initWithAccessToEntityTypes EKEntityTypeEvent | EKEntityTypeReminder
cals = store.calendarsForEntityType(EKEntityTypeEvent)

cals.each do |calendar|
print calendar.calendarIdentifier + " " + calendar.title + "\n"
end
