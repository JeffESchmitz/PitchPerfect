//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jeff Schmitz on 12/8/15.
//  Copyright © 2015 Jeff Schmitz. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}