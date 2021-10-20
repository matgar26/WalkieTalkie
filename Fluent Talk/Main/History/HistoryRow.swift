//
//  HistoryRow.swift
//  Fluent Talk
//
//  Created by Matt Gardner on 9/30/21.
//

import SwiftUI
import UIKit
import AVKit

struct HistoryRow: View {
    let transmition: Transmition
    let type: HistoryType
    var player: AVPlayer!

    var body: some View {
        ZStack {
            Color.white
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if type == .outbound || type == .both {
                        Text("To: \(transmition.username_to)")
                            .font(.callout)
                    }
                    if type == .inbound || type == .both {
                        Text("From: \(transmition.username_from)")
                            .font(.callout)
                    }
                    
                    Text(transmition.dateString ?? "")
                        .font(.subheadline)
                }
                Spacer()
                AVPlayerButton(state: .play) {
                    
                }
            }
            .padding(.horizontal, 17)
            .padding(.vertical, 20)
        }
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.11), radius: 16, x: 0, y: 14)
    }
}

struct HistoryRow_Previews: PreviewProvider {
    static var previews: some View {
        HistoryRow(transmition: Transmition(), type: .both)
    }
}

