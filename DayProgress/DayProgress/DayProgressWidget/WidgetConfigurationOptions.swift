//
//  WidgetConfigurationOptions.swift
//  DayProgress
//
//  Created by Abdulkarim Mziya on 2026-04-16.
//

import AppIntents

// AppEnum is what tells iOS to render this as a native picker.
enum WidgetTheme: String, AppEnum {
    case blue, orange, green, pink
    
    // This label appears as the row title in the edit sheet
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Color theme"
    
    // What each case shows as in the picker list
    static var caseDisplayRepresentations: [WidgetTheme: DisplayRepresentation] = [
        .blue:      "Blue",
        .orange:    "Orange",
        .green:     "Green",
        .pink:      "Pink"
    ]
}

enum PrimaryDisplay: String, AppEnum {
    case time, percentage
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Show"
    
    static var caseDisplayRepresentations: [PrimaryDisplay : DisplayRepresentation] = [
        .time:          "Time",
        .percentage:    "Percentage"
    ]
    
}

struct DayProgressIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Day Progress"
    static var description = IntentDescription("Customise your Day Progress widget.")
    
    // Each @Parameter becomes one row in the edit sheet.
    // The 'title' is the row label. 'default' is the pre-set value.
    @Parameter(title: "Color theme", default: .blue)
    var theme: WidgetTheme
    
    @Parameter(title: "Show", default: .time)
    var primaryDisplay: PrimaryDisplay
}
