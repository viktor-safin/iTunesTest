//
//  MusicPlaySwiftUIView.swift
//  iTunesTest
//
//  Created by Виктор on 01.05.2024.
//

import SwiftUI
import SwiftAudio

final class MusicPlayViewModel: ObservableObject {
    
    let player = AudioPlayer()
        
    @Published var playerState: AudioPlayerState = .idle
    
    deinit {
        print("MusicPlayViewModel deinited")
    }
    func load(trackURL: String) {
        player.event.stateChange.addListener(self, handleAudioPlayerStateChange)
        
        let audioItem = DefaultAudioItem(audioUrl: trackURL, sourceType: .stream)
        try? player.load(item: audioItem, playWhenReady: false)
        

    }
    

    private func handleAudioPlayerStateChange(state: AudioPlayerState) {
        DispatchQueue.main.async {
            self.playerState = state
        }
    }
}
// MARK: - MainView

struct MusicPlaySwiftUIView: View {
    
    @StateObject var viewModel = MusicPlayViewModel()
    
    
    let data: MusicData
        
    var body: some View {
        
        VStack {
            AsyncImage(url: URL(string: data.imageURL)) { img in
                switch img {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.2)
                        ProgressView()
                    }
                case .success(let image):
                    image.resizable()
                case .failure(let error):
                    Text(error.localizedDescription)

                @unknown default:
                    EmptyView()
                }
            }
            
            .cornerRadius(10)
            .frame(width: 300, height: 300, alignment: .top)
            .modifier(MusicSceneShadow())
            .padding()
            
            Text(data.artistName)
                .fontWeight(.black)
                .padding(5)
            Text(data.collectionName).padding(5)
            
            let buttonSise: CGFloat = 50
            
            PlayingButtonView(playerState: $viewModel.playerState) {
                
                viewModel.player.togglePlaying()
            }
            .frame(width:buttonSise, height: buttonSise)
            .background(Color.green)
            .cornerRadius(50)
            .modifier(MusicSceneShadow())
            
        }.onAppear {
            viewModel.load(trackURL: data.trackURL)

        }.task {
            
        }
    }
    
    
}


// MARK: - CustViews

private struct PlayingButtonView: View {
    
    @Binding var playerState: AudioPlayerState
    
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
            
        }, label: {
            Image(systemName: playerState != .playing ? "play.fill" : "stop.fill")
                .frame(width: 30, height: 30)
        })
    }
}

private struct MusicSceneShadow: ViewModifier {
    
    func body(content: Content) -> some View {
        content.shadow(color: .black.opacity(0.5),
                       radius: 10, y: 10)
    }
}

// MARK: - Preview Provider

struct MusicSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        
        let previewMusicData = MusicData(artistName: "Artist Name",
                                         collectionName: "Collection Name",
                                         trackName: "Track Name",
                                         imageURL: "https://i.pinimg.com/736x/cc/25/91/cc25911a8e23fa11515ed0eb06ee6785.jpg",
                                         trackURL: "")
        MusicPlaySwiftUIView(data: previewMusicData)
    }
}
