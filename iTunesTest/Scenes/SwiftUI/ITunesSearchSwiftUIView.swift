//
//  ITunesSearchUIView.swift
//  iTunesTest
//
//  Created by Виктор on 28.04.2024.
//

import Combine
import SwiftUI

struct MusicRow: View {
    var data: MusicData
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: data.imageURL)) { img in
                img.resizable()
            } placeholder: {
                Text("load")
            }
            .frame(width: 100, height: 100)
            

            VStack(alignment: .leading, spacing: .pi, content: {
                Text("\(data.artistName)")
                    .frame(height: 50, alignment: .topLeading)
                    .lineLimit(1)
                    
                Text("\(data.collectionName)")
                    .frame(alignment: .topLeading)
                    .lineLimit(2)
            })
        }
    }
}


class AppRouter: ObservableObject {
    
    // MARK: - Methods
    @ViewBuilder func musicSwiftUIView(with musicData: MusicData) -> some View {
        MusicPlaySwiftUIView(data: musicData)
    }
    
    @ViewBuilder func musicRow(with musicData: MusicData) -> some View {
        MusicRow(data: musicData)
    }
    
}

struct ITunesSearchUIView: View {
    
    let router: AppRouter
    
    @EnvironmentObject var viewModel: ITunesSearchViewModel

    //    var viewModel: ITunesSearchViewModel
    
    var body: some View {
                    
            List {
                ForEach(viewModel.searchedMusicResult, id: \.id) { item in
                    NavigationLink(destination: router.musicSwiftUIView(with: item)) {
                        router.musicRow(with: item)
                    }
                }
                .listRowBackground(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 15)
                    
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                )
                .listRowSeparator(.hidden)
                .foregroundColor(.indigo)
            }
            .listStyle(.plain)
            .onAppear {
//                viewModel.sutup()
                viewModel.searchText = "deep" // for test
            }
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { newValue in

                print("searchText = \(newValue)")
            }.overlay(alignment: .center) {
                Text(viewModel.searchedMusicResult.isEmpty
                     ? "Нет данных" : "")
                .font(.body)
            }
    }
}

// MARK: - PreviewProvider

struct ITunesSearchUIView_Previews: PreviewProvider {
    static var previews: some View {
        
        let networkService = ITunesSearchNetworkService()
        let viewModel = ITunesSearchViewModel(networkService: networkService)
        
        NavigationView {
            let appRouter = AppRouter()
            ITunesSearchUIView(router: appRouter)
                .environmentObject(viewModel)
                .onAppear {
                    viewModel.searchText = "inna" // test
                }
        }
    }
}
