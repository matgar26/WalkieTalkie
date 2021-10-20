//
//  HistoryView.swift
//  Fluent Talk
//
//  Created by Matt Gardner on 9/30/21.
//

import SwiftUI
import AVKit

struct HistoryView: View {
    @ObservedObject private var viewModel = HistoryViewModel()
    @State private var isPresented = false
    @State var audioPlayer: AVPlayer!

    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 16) {
                    Picker("", selection: $viewModel.selectedTypeIndex, content: {
                                    Text("Incoming").tag(0)
                                    Text("Outgoing").tag(1)
                                    if UserManager.shared.isAdmin {
                                        Text("All").tag(2)
                                    }
                                })
                                .pickerStyle(SegmentedPickerStyle())
                    
                    SearchBar(text: $viewModel.searchText, isEditing: $viewModel.isEditing)
                }
                .padding(.horizontal, 16)
                                
                ZStack {
                    Color.mainBackground
                    ScrollView {
                        RefreshControl(coordinateSpaceName: "pullToRefresh", onRefresh: {
                            self.viewModel.refreshData()
                        }, needRefresh: self.viewModel.isLoading)
                                                
                        LazyVStack(spacing: 24) {
                            ForEach(viewModel.isEditing ? viewModel.searchHistory : viewModel.history) { transmition in
                                HistoryRow(transmition: transmition, type: viewModel.type)
                            }
                        }
                        .coordinateSpace(name: "pullToRefresh")
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                    }
                }
                .onAppear(perform: {
                    viewModel.refreshData()
                })
                .navigationTitle("History")
                .toolbar {
                    Button("New") {
                        isPresented.toggle()
                    }
                    .sheet(isPresented: $isPresented, onDismiss: nil) {
//                        TalkView()
                    }
                }
                .navigationBarHidden(viewModel.isEditing).animation(.linear(duration: 0.25))
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
