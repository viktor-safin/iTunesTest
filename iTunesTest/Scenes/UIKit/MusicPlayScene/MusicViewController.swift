//
//  MusicViewController.swift
//  iTunesTest
//
//  Created by Виктор on 16.04.2024.
//

import UIKit
import Combine
import SwiftAudio

final class MusicViewModel {
    
    @Published var musicCellModel: MusicData
    
    init(musicCellModel: MusicData) {
        self.musicCellModel = musicCellModel
    }
}

final class MusicViewController: UIViewController {

    @IBOutlet private weak var ibImageView: UIImageView!
    @IBOutlet private weak var ibTopTitle: UILabel!
    @IBOutlet private weak var ibCenterTitle: UILabel!
    @IBOutlet private weak var ibBottomTitle: UILabel!
    
    @IBOutlet private weak var ibPlayButton: UIButton!
    
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel: MusicViewModel!
    var router: MainRouterProtocol!
    
    private let player = AudioPlayer()
//    private let player = QueuedAudioPlayer()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindings()
        
        
        
    }
    
    
    private func handleAudioPlayerStateChange(state: AudioPlayerState) {
        print(state)
        
        DispatchQueue.main.async {
            switch state {
            case .loading, .ready, .buffering, .idle:
                break
            case .paused:
                self.ibPlayButton.setImage(UIImage(systemName: "play.fill"),
                                           for: .normal)
            case .playing:
                self.ibPlayButton.setImage(UIImage(systemName: "stop.fill"),
                                           for: .normal)
                }
        }
        
    }
    
    private func bindings() {
        viewModel.$musicCellModel.sink { [unowned self] music in
            ibImageView.load(urlString: music.imageURL)
            
            ibTopTitle.text = music.artistName
            ibCenterTitle.text = music.trackName
            ibBottomTitle.text = music.collectionName
            
            let audioItem = DefaultAudioItem(audioUrl: music.trackURL, sourceType: .stream)
            try? player.load(item: audioItem, playWhenReady: false)
            
        }.store(in: &cancellables)
    }

    @IBAction private func ibCloseButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction private func ibPlayAction(_ sender: Any) {
        player.playerState == .playing ? player.pause() : player.play()
        
    }
}
