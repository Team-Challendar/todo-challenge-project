//
//  WidgetIntentsBundle.swift
//  WidgetIntents
//
//  Created by 채나연 on 6/19/24.
//

import WidgetKit
import SwiftUI

@main
struct WidgetIntentsBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        TodoWidget()
    }
}
