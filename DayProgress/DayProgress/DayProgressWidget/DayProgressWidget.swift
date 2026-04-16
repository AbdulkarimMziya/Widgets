//
//  DayProgressWidget.swift
//  DayProgressWidget
//
//  Created by Abdulkarim Mziya on 2026-04-15.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DayProgressEntry {
        makeEntry(for: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (DayProgressEntry) -> ()) {
        let entry = makeEntry(for: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DayProgressEntry] = []
        
        let now = Date()
        let calendar = Calendar.current
    
        // Start of dat (midnight)
        
        let midnight = calendar.startOfDay(for: now)
    
        for hours in 0 ..< 24 {
            if let date = calendar.date(byAdding: .hour, value: hours, to: midnight) {
                entries.append(makeEntry(for: date))
            }
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func makeEntry(for date: Date) -> DayProgressEntry {
        let now = Date()
        let calendar = Calendar.current
        
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let totalDayHours = endOfDay.timeIntervalSince(startOfDay)
        let currentDayHours = date.timeIntervalSince(startOfDay)
        
        // Get the percentage of the day
        let percentage = min(currentDayHours / totalDayHours, 1.0)
        
        // Format the time for display
        let formatedDate = date.formatted(date: .omitted, time: .shortened)
        
        return DayProgressEntry(date: date, percentage: percentage, timeString: formatedDate)
    }
    
}

struct DayProgressEntry: TimelineEntry {
    let date: Date
    let percentage: Double
    let timeString: String
}

struct DayProgressWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Day Progress")
                .font(.system(size: 14))
                .fontWeight(.bold)
            
            Spacer()
            
            Text(entry.timeString)

            ProgressView(value: entry.percentage)
                .tint(.blue)
                .background(.gray)
                .clipShape(.capsule)
                .scaleEffect(x: 1, y: 1.5)
            
            Spacer()
            
            Text("\(Int(entry.percentage * 100))% of the day is done.")
                .font(.caption2)
            
        }.padding()
    }
}

struct DayProgressWidget: Widget {
    let kind: String = "DayProgressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DayProgressWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DayProgressWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Day Progress Widget")
        .description("See how much of the day has passed.")
    }
}

#Preview(as: .systemMedium) {
    DayProgressWidget()
} timeline: {
    DayProgressEntry(date: .now, percentage: 0.75, timeString: Date().formatted(date: .omitted, time: .shortened))
}

