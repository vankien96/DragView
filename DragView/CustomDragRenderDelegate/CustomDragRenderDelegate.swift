//
//  CustomDragRenderDelegate.swift
//  DragView
//
//  Created by Trương Văn Kiên on 6/14/18.
//  Copyright © 2018 Trương Văn Kiên. All rights reserved.
//

import Foundation
import BetweenKit

protocol DragCallbacks: NSObjectProtocol {
    func draggingForm(_ coordinator: I3GestureCoordinator?)
}

class CustomDragRenderDelegate: I3BasicRenderDelegate {
    weak var callBacks: DragCallbacks?
    
    override func renderDragging(from coordinator: I3GestureCoordinator?) {
        super.renderDragging(from: coordinator)
        callBacks?.draggingForm(coordinator)
    }
}
