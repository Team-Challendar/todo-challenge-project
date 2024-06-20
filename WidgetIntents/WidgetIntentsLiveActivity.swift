////
////  WidgetIntentsLiveActivity.swift
////  WidgetIntents
////
////  Created by 채나연 on 6/19/24.
////
//
//import ActivityKit
//import WidgetKit
//import SwiftUI
//
//struct WidgetIntentsAttributes: ActivityAttributes {
//    public struct ContentState: Codable, Hashable {
//        // Dynamic stateful properties about your activity go here!
//        var emoji: String
//    }
//
//    // Fixed non-changing properties about your activity go here!
//    var name: String
//}
//
//struct WidgetIntentsLiveActivity: Widget {
//    var body: some WidgetConfiguration {
//        ActivityConfiguration(for: WidgetIntentsAttributes.self) { context in
//            // Lock screen/banner UI goes here
//            VStack {
//                Text("Hello \(context.state.emoji)")
//            }
//            .activityBackgroundTint(Color.cyan)
//            .activitySystemActionForegroundColor(Color.black)
//
//        } dynamicIsland: { context in
//            DynamicIsland {
//                // Expanded UI goes here.  Compose the expanded UI through
//                // various regions, like leading/trailing/center/bottom
//                DynamicIslandExpandedRegion(.leading) {
//                    Text("Leading")
//                }
//                DynamicIslandExpandedRegion(.trailing) {
//                    Text("Trailing")
//                }
//                DynamicIslandExpandedRegion(.bottom) {
//                    Text("Bottom \(context.state.emoji)")
//                    // more content
//                }
//            } compactLeading: {
//                Text("L")
//            } compactTrailing: {
//                Text("T \(context.state.emoji)")
//            } minimal: {
//                Text(context.state.emoji)
//            }
//            .widgetURL(URL(string: "http://www.apple.com"))
//            .keylineTint(Color.red)
//        }
//    }
//}
//
//extension WidgetIntentsAttributes {
//    fileprivate static var preview: WidgetIntentsAttributes {
//        WidgetIntentsAttributes(name: "World")
//    }
//}
//
//extension WidgetIntentsAttributes.ContentState {
//    fileprivate static var smiley: WidgetIntentsAttributes.ContentState {
//        WidgetIntentsAttributes.ContentState(emoji: "😀")
//     }
//     
//     fileprivate static var starEyes: WidgetIntentsAttributes.ContentState {
//         WidgetIntentsAttributes.ContentState(emoji: "🤩")
//     }
//}
//
////#Preview("Notification", as: .content, using: WidgetIntentsAttributes.preview) {
////   WidgetIntentsLiveActivity()
////} contentStates: {
////    WidgetIntentsAttributes.ContentState.smiley
////    WidgetIntentsAttributes.ContentState.starEyes
////}
