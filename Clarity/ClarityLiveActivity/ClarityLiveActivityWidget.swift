//
//  ClarityLiveActivityWidget.swift
//  ClarityLiveActivity
//
//  Widget Extension Entry Point
//

import WidgetKit
import SwiftUI

@main
struct ClarityLiveActivityWidget: WidgetBundle {
    var body: some Widget {
        if #available(iOS 16.2, *) {
            StudyLiveActivity()
        }
    }
}
