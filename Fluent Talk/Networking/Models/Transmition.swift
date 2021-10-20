//
//  Transmition.swift
//  Fluent Talk
//
//  Created by Matt Gardner on 9/30/21.
//

import Foundation
import SwiftUI

struct Transmition: Decodable, Identifiable {
    var id: Int
    var username_from: String
    var dateString: String?
    var recording: String?
    var username_to: String
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.isLenient = true
        formatter.dateFormat = "MM/dd/yy, hh:mm a"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, recording, timestamp, username_to, username_from
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        username_from = try container.decodeIfPresent(.username_from) ?? "Unknown"
        recording = try container.decodeIfPresent(.recording)
        username_to = try container.decodeIfPresent(.username_to) ?? "Unknown"
        
        if let timestamp: String = try container.decodeIfPresent(.timestamp), let timeInterval = TimeInterval(timestamp) {
            let date = Date(timeIntervalSince1970: timeInterval)
            dateString = dateFormatter.string(from: date)
        }
    }
    
    init() {
        self.username_from = "mgardner"
        self.username_to = "tester3"
        self.id = 1
        self.dateString = "12/10/20 1:45pm"
    }
}


extension KeyedDecodingContainer {
    public func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        return try? decodeIfPresent(T.self, forKey: key)
    }
}
