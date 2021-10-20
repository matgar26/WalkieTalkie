//
//  HistoryViewModel.swift
//  Fluent Talk
//
//  Created by Matt Gardner on 9/30/21.
//

import Foundation
import Combine
import AVKit

class HistoryViewModel: ObservableObject, TransmissionService {
    internal var apiSession: APIService
    private var cancellables = Set<AnyCancellable>()
    private let player: AVPlayer

    init(apiSession: APIService = APISession()) {
        self.apiSession = apiSession
        
        let url = URL(string: "http://localhost:3000/recording")!
        player = AVPlayer(playerItem: AVPlayerItem(url: url))
    }
    
    private var unfilteredHistoryList: [Transmition] = []
    var type: HistoryType = .inbound
    var isLoading: Bool = false
    
    @Published var isEditing = false {
        didSet {
            searchText = ""
        }
    }
    
    @Published private(set) var history: [Transmition] = []
    @Published private(set) var searchHistory: [Transmition] = []

    @Published var searchText = "" {
        didSet {
            searchData()
        }
    }
    
    @Published var selectedTypeIndex = 0 {
        didSet {
            switch selectedTypeIndex {
            case 0: type = .inbound
            case 1: type = .outbound
            default: type = .both
            }
            filterData()
        }
    }
    
    func refreshData() {
        isLoading = true
        let cancellable = self.getTransitionHistoryList()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(let error):
                    print("Handle error: \(error)")
                case .finished:
                    break
                }
            }) { list in
                self.unfilteredHistoryList = list
                self.filterData()
            }
        cancellables.insert(cancellable)
    }
    
    func filterData() {
        switch type {
        case .both:
            history = unfilteredHistoryList
        case .inbound:
            history = unfilteredHistoryList.filter({$0.username_to == UserManager.shared.userName})
        case .outbound:
            history = unfilteredHistoryList.filter({$0.username_from == UserManager.shared.userName})
        }
        isLoading = false
        
        if isEditing {
            searchData()
        }
    }
    
    func searchData() {
        let search = searchText.lowercased()
        if !search.isEmpty {
            self.searchHistory = history.filter({$0.username_to.lowercased().contains(search) || $0.username_from.lowercased().contains(search)})
        } else {
            self.searchHistory = history
        }
    }
    
    func playRecording() {
        let currentItem = player.currentItem
        if currentItem?.currentTime() == currentItem?.duration {
            currentItem?.seek(to: .zero, completionHandler: nil)
        }
        
        player.play()
    }
    
    func pauseRecording() {
        player.pause()
    }
}
