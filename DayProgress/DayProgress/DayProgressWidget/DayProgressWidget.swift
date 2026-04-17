//
//  DayProgressWidget.swift
//  DayProgressWidget
//
//  Created by Abdulkarim Mziya on 2026-04-15.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    // 1. Placeholder remains synchronous
    func placeholder(in context: Context) -> DayProgressEntry {
        DayProgressEntry(date: Date(), percentage: 0.54, timeString: "17:38Pm", theme: .blue, primaryDisplay: .time)
    }
    
    // 2. Snapshot must be async and return the entry directly
    func snapshot(for configuration: DayProgressIntent, in context: Context) async -> DayProgressEntry {
        makeEntry(for: Date(), configuration: configuration)
    }
    
    // 3. Timeline must be async and return the Timeline object directly
    func timeline(for configuration: DayProgressIntent, in context: Context) async -> Timeline<DayProgressEntry> {
        var entries: [DayProgressEntry] = []
        let now = Date()
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: now)
        
        for hours in 0 ..< 24 {
            if let date = calendar.date(byAdding: .hour, value: hours, to: midnight) {
                entries.append(makeEntry(for: date, configuration: configuration))
            }
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    private func makeEntry(for date: Date, configuration: DayProgressIntent) -> DayProgressEntry {
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
        
        return DayProgressEntry(
            date: date,
            percentage: percentage,
            timeString: formatedDate,
            theme: configuration.theme,
            primaryDisplay: configuration.primaryDisplay
        )
    }
        
}


struct DayProgressEntry: TimelineEntry {
    let date: Date
    let percentage: Double
    let timeString: String
    
    
    let theme: WidgetTheme
    let primaryDisplay: PrimaryDisplay
}

struct DayProgressWidgetEntryView : View {
    var entry: Provider.Entry
    
    var accentColor: Color {
        switch entry.theme {
        case .blue:   return .blue
        case .green:  return .green
        case .orange: return .orange
        case .pink:   return .pink
        }
    }

    var body: some View {
        VStack {
            Text("Day Progress")
                .font(.system(size: 14))
                .fontWeight(.bold)
            
            Spacer()
            
            switch entry.primaryDisplay {
            case .percentage:
                Text("\(Int(entry.percentage * 100))%")
                    .font(.title2).bold()
                    .foregroundStyle(accentColor)
            case .time:
                Text(entry.timeString)
                    .font(.title2).bold()
                    .foregroundStyle(accentColor)
            }

            ProgressView(value: entry.percentage)
                .tint(accentColor)
                .background(.gray)
                .clipShape(.capsule)
                .scaleEffect(x: 1, y: 1.5)
            
            Spacer()
            
            Text("\(Int(entry.percentage * 100))% of day done.")
                .font(.caption2)
            
        }.padding()
    }
}

struct DayProgressWidget: Widget {
    let kind: String = "DayProgressWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind,intent: DayProgressIntent.self ,provider: Provider()) { entry in
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

#Preview(as: .systemSmall) {
    DayProgressWidget()
} timeline: {
    DayProgressEntry(date: .now, percentage: 0.75, timeString: Date().formatted(date: .omitted, time: .shortened), theme: .blue, primaryDisplay: .percentage)
}

