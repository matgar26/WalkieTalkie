//
//  AVPlayerButton.swift
//  Fluent Talk
//
//  Created by Matt Gardner on 10/19/21.
//

import Foundation
import SwiftUI

struct AVPlayerButton: View {
    let state: AVPlayerButtonState
    var action: ()->Void

    var body: some View {
        switch state {
        case .loading: Text("Loading..")
        case .play, .stop:
            Button(action: {
                self.action()
            }) {
                Image(systemName: state == .play ? "play.circle.fill" : "pause.circle.fill").resizable()
                    .frame(width: 25, height: 25)
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
    
    enum AVPlayerButtonState {
        case loading
        case play
        case stop
    }
}
