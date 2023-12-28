//
//  SessionWidgetBundle.swift
//  SessionWidget
//
//  Created by Jonathan Sillak on 29.12.2023.
//

import WidgetKit
import SwiftUI

@main
struct SessionWidgetBundle: WidgetBundle {
    var body: some Widget {
        SessionWidget()
        SessionWidgetLiveActivity()
    }
}
