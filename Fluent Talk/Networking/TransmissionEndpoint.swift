//
//  TransmissionEndpoint.swift
//  Fluent Talk
//
//  Created by Matt Gardner on 10/1/21.
//

import Foundation
import Combine

enum TransmissionEndpoint {
    case transmissionHistory
}

extension TransmissionEndpoint: RequestBuilder {
    
    var urlRequest: URLRequest {
        switch self {
        case .transmissionHistory:
            guard let url = URL(string: "http://localhost:3000/history")
                else {preconditionFailure("Invalid URL format")}
            let request = URLRequest(url: url)
            return request
        }
    }
}

protocol TransmissionService {
    var apiSession: APIService {get}
    
    func getTransitionHistoryList() -> AnyPublisher<[Transmition], APIError>
}

extension TransmissionService {
    func getTransitionHistoryList() -> AnyPublisher<[Transmition], APIError> {
        return apiSession.request(with: TransmissionEndpoint.transmissionHistory)
            .eraseToAnyPublisher()
    }
}
