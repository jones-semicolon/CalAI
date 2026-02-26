import SwiftUI
import WidgetKit

private let appGroupID = "group.com.example.calai"

private enum WidgetKeys {
    static let calories = "calai_widget_calories"
    static let calorieGoal = "calai_widget_calorie_goal"
    static let protein = "calai_widget_protein"
    static let proteinGoal = "calai_widget_protein_goal"
    static let carbs = "calai_widget_carbs"
    static let carbsGoal = "calai_widget_carbs_goal"
    static let fats = "calai_widget_fats"
    static let fatsGoal = "calai_widget_fats_goal"
    static let streakCount = "calai_widget_streak_count"
}

struct CalAIWidgetEntry: TimelineEntry {
    let date: Date
    let calories: Int
    let calorieGoal: Int
    let protein: Int
    let proteinGoal: Int
    let carbs: Int
    let carbsGoal: Int
    let fats: Int
    let fatsGoal: Int
    let streakCount: Int

    static let placeholder = CalAIWidgetEntry(
        date: Date(),
        calories: 1240,
        calorieGoal: 2000,
        protein: 80,
        proteinGoal: 130,
        carbs: 120,
        carbsGoal: 220,
        fats: 45,
        fatsGoal: 70,
        streakCount: 6
    )
}

struct CalAIWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> CalAIWidgetEntry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (CalAIWidgetEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CalAIWidgetEntry>) -> Void) {
        let entry = readEntry()
        let refresh = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
        completion(Timeline(entries: [entry], policy: .after(refresh)))
    }

    private func readEntry() -> CalAIWidgetEntry {
        let defaults = UserDefaults(suiteName: appGroupID)
        return CalAIWidgetEntry(
            date: Date(),
            calories: readInt(defaults, key: WidgetKeys.calories, fallback: 0),
            calorieGoal: max(1, readInt(defaults, key: WidgetKeys.calorieGoal, fallback: 2000)),
            protein: readInt(defaults, key: WidgetKeys.protein, fallback: 0),
            proteinGoal: max(1, readInt(defaults, key: WidgetKeys.proteinGoal, fallback: 130)),
            carbs: readInt(defaults, key: WidgetKeys.carbs, fallback: 0),
            carbsGoal: max(1, readInt(defaults, key: WidgetKeys.carbsGoal, fallback: 220)),
            fats: readInt(defaults, key: WidgetKeys.fats, fallback: 0),
            fatsGoal: max(1, readInt(defaults, key: WidgetKeys.fatsGoal, fallback: 70)),
            streakCount: max(0, readInt(defaults, key: WidgetKeys.streakCount, fallback: 0))
        )
    }

    private func readInt(_ defaults: UserDefaults?, key: String, fallback: Int) -> Int {
        guard let defaults else { return fallback }
        if let value = defaults.object(forKey: key) as? NSNumber {
            return value.intValue
        }
        if let value = defaults.object(forKey: key) as? Int {
            return value
        }
        if let value = defaults.object(forKey: key) as? String, let parsed = Int(value) {
            return parsed
        }
        return fallback
    }
}

private struct Theme {
    let background: Color
    let border: Color
    let primary: Color
    let secondary: Color
    let track: Color
    let pill: Color

    static func from(_ scheme: ColorScheme) -> Theme {
        if scheme == .dark {
            return Theme(
                background: Color(red: 0.184, green: 0.161, blue: 0.208),
                border: Color(red: 0.227, green: 0.227, blue: 0.235),
                primary: .white,
                secondary: Color(red: 0.690, green: 0.690, blue: 0.710),
                track: Color(red: 0.227, green: 0.227, blue: 0.235),
                pill: Color(red: 0.957, green: 0.957, blue: 0.973)
            )
        }
        return Theme(
            background: Color(red: 0.976, green: 0.973, blue: 0.992),
            border: Color(red: 0.894, green: 0.886, blue: 0.918),
            primary: Color(red: 0.067, green: 0.067, blue: 0.067),
            secondary: Color(red: 0.431, green: 0.431, blue: 0.451),
            track: Color(red: 0.894, green: 0.894, blue: 0.918),
            pill: Color(red: 0.184, green: 0.161, blue: 0.208)
        )
    }
}

private struct CardBackground: View {
    let theme: Theme

    var body: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(theme.background)
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(theme.border, lineWidth: 1)
            )
    }
}

private struct RingView: View {
    let progress: Double
    let track: Color
    let fill: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(track, lineWidth: 7)
            Circle()
                .trim(from: 0, to: max(0, min(1, progress)))
                .stroke(fill, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

private struct MacroRow: View {
    let dotColor: Color
    let valueText: String
    let subtitle: String
    let theme: Theme

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(dotColor)
                .frame(width: 12, height: 12)
            VStack(alignment: .leading, spacing: 1) {
                Text(valueText)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(theme.primary)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(theme.secondary)
                    .lineLimit(1)
            }
        }
    }
}

private struct CaloriesWidgetView: View {
    @Environment(\.colorScheme) private var colorScheme
    let entry: CalAIWidgetEntry

    var body: some View {
        let theme = Theme.from(colorScheme)
        let left = entry.calorieGoal - entry.calories
        let isLeft = left >= 0
        let progress = Double(entry.calories) / Double(max(1, entry.calorieGoal))

        ZStack {
            CardBackground(theme: theme)
            VStack(spacing: 10) {
                ZStack {
                    RingView(progress: progress, track: theme.track, fill: theme.primary)
                        .frame(width: 92, height: 92)
                    VStack(spacing: 2) {
                        Text("\(abs(left))")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(theme.primary)
                        Text(isLeft ? "Calories left" : "Calories over")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(theme.secondary)
                    }
                }
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                        .font(.system(size: 11, weight: .bold))
                    Text("Log your food")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundColor(theme.background)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(
                    Capsule(style: .continuous)
                        .fill(theme.pill)
                )
            }
            .padding(10)
        }
        .widgetURL(URL(string: "calai://home"))
    }
}

private struct NutritionWidgetView: View {
    @Environment(\.colorScheme) private var colorScheme
    let entry: CalAIWidgetEntry

    var body: some View {
        let theme = Theme.from(colorScheme)
        let progress = Double(entry.calories) / Double(max(1, entry.calorieGoal))
        let proteinLeft = entry.proteinGoal - entry.protein
        let carbsLeft = entry.carbsGoal - entry.carbs
        let fatsLeft = entry.fatsGoal - entry.fats

        ZStack {
            CardBackground(theme: theme)
            HStack(spacing: 12) {
                ZStack {
                    RingView(progress: progress, track: theme.track, fill: theme.primary)
                        .frame(width: 92, height: 92)
                    VStack(spacing: 1) {
                        Text("\(max(0, entry.calorieGoal - entry.calories))")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(theme.primary)
                        Text("Calories left")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(theme.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: 7) {
                    MacroRow(
                        dotColor: Color(red: 0.866, green: 0.412, blue: 0.412),
                        valueText: "\(abs(proteinLeft))g",
                        subtitle: proteinLeft >= 0 ? "Protein left" : "Protein over",
                        theme: theme
                    )
                    MacroRow(
                        dotColor: Color(red: 0.871, green: 0.604, blue: 0.412),
                        valueText: "\(abs(carbsLeft))g",
                        subtitle: carbsLeft >= 0 ? "Carbs left" : "Carbs over",
                        theme: theme
                    )
                    MacroRow(
                        dotColor: Color(red: 0.412, green: 0.596, blue: 0.871),
                        valueText: "\(abs(fatsLeft))g",
                        subtitle: fatsLeft >= 0 ? "Fats left" : "Fats over",
                        theme: theme
                    )
                }
                Spacer(minLength: 0)
            }
            .padding(12)
        }
        .widgetURL(URL(string: "calai://home"))
    }
}

private struct StreakWidgetView: View {
    @Environment(\.colorScheme) private var colorScheme
    let entry: CalAIWidgetEntry

    var body: some View {
        let theme = Theme.from(colorScheme)
        let fillColor: Color = (colorScheme == .dark) ? .black : .white
        let outlineColor = Color(red: 0.965, green: 0.655, blue: 0.247)

        ZStack {
            CardBackground(theme: theme)
            ZStack {
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: "sparkle")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(red: 0.973, green: 0.906, blue: 0.659))
                        Spacer()
                        Image(systemName: "sparkle")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red: 0.949, green: 0.710, blue: 0.498))
                    }
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.top, 10)

                Image(systemName: "flame.fill")
                    .font(.system(size: 86))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.996, green: 0.769, blue: 0.376),
                                Color(red: 0.965, green: 0.584, blue: 0.208)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                ZStack {
                    // Multi-direction shadow offset to fake stroke around text.
                    ForEach(Array([
                        CGSize(width: -1.3, height: 0),
                        CGSize(width: 1.3, height: 0),
                        CGSize(width: 0, height: -1.3),
                        CGSize(width: 0, height: 1.3),
                        CGSize(width: -1.0, height: -1.0),
                        CGSize(width: 1.0, height: -1.0),
                        CGSize(width: -1.0, height: 1.0),
                        CGSize(width: 1.0, height: 1.0),
                    ].enumerated()), id: \.offset) { _, offset in
                        Text("\(entry.streakCount)")
                            .font(.system(size: 52, weight: .black, design: .rounded))
                            .foregroundColor(outlineColor)
                            .offset(offset)
                    }
                    Text("\(entry.streakCount)")
                        .font(.system(size: 50, weight: .black, design: .rounded))
                        .foregroundColor(fillColor)
                }
                .offset(y: 20)
            }
        }
        .widgetURL(URL(string: "calai://home"))
    }
}

struct CalAICaloriesWidget: Widget {
    let kind = "CalAIHomeWidgetCalories"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalAIWidgetProvider()) { entry in
            CaloriesWidgetView(entry: entry)
        }
        .configurationDisplayName("Cal AI - Calorie Tracker")
        .description("Calorie tracker widget")
        .supportedFamilies([.systemSmall])
    }
}

struct CalAINutritionWidget: Widget {
    let kind = "CalAIHomeWidgetNutrition"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalAIWidgetProvider()) { entry in
            NutritionWidgetView(entry: entry)
        }
        .configurationDisplayName("Cal AI - Nutrition Widget")
        .description("Nutrition tracker widget (4x2)")
        .supportedFamilies([.systemMedium])
    }
}

struct CalAIStreakWidget: Widget {
    let kind = "CalAIHomeWidgetStreak"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CalAIWidgetProvider()) { entry in
            StreakWidgetView(entry: entry)
        }
        .configurationDisplayName("Cal AI - Streak Widget")
        .description("Streak tracker widget")
        .supportedFamilies([.systemSmall])
    }
}

@main
struct CalAIHomeWidgetsBundle: WidgetBundle {
    var body: some Widget {
        CalAICaloriesWidget()
        CalAINutritionWidget()
        CalAIStreakWidget()
    }
}
