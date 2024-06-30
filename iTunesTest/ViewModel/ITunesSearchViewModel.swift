//
//  ITunesSearchViewModel.swift
//  iTunesTest
//
//  Created by Виктор on 05.03.2024.
//

import Foundation
import Combine

// MARK: View model

final class ITunesSearchViewModel: ObservableObject, Identifiable {
    
    
    @Published var searchText = ""
//    @Published private(set) var content = ITunesSearchResult()
    
    @Published private(set) var searchedMusicResult: [MusicData] = []
    
    private let networkService: ITunesSearchNetworkServiceProtocol
    
    private var cancelable = Set<AnyCancellable>()
    
    init(networkService: ITunesSearchNetworkServiceProtocol) {
        self.networkService = networkService
        sutup()
    }
    
    func sutup() {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .flatMap({ (text: String) -> AnyPublisher<ITunesSearchResult, Error> in
                self.networkService.searchMusicPublisher(with: text)
            })
            .catch({ error in
                // todo processing errors
                return Just(ITunesSearchResult()).eraseToAnyPublisher()
            })
                .flatMap({ arr in
                    return Just(arr.results.map { tt in
                        MusicData(artistName: tt.artistName,
                                  collectionName: tt.collectionName ?? "",
                                  trackName: tt.trackName ?? "",
                                  imageURL: tt.artworkUrl100 ?? "",
                                  trackURL: tt.previewURL ?? "")
                    }).eraseToAnyPublisher()
                    
                })
            .assign(to: \.searchedMusicResult, on: self)
            .store(in: &cancelable)
    }
}
