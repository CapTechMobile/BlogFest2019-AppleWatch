//
//  ContentView.swift
//  Watch Stream WatchKit Extension
//
//  Created by John Morrison on 6/15/19.
//  Copyright © 2019 Captech Consulting Inc. All rights reserved.
//

import SwiftUI
import AVFoundation

private let session = AVAudioSession.sharedInstance()
private let podcastURLstring = "https://media.blubrry.com/dataguruspodcast/b/content.blubrry.com/dataguruspodcast/DGP_Ben_Harden_036.mp3"
private var player: AVPlayer?
private var playerItem: AVPlayerItem?

struct ContentView : View {
    
    @State var playing = false
    
    var body: some View {
        VStack {
            
            Text("Watch Stream").font(.headline)
            
            Button(action: {
                playPauseActionHandler { (success) in
                    self.playing = success
                }
            }) {
                
                playing ? Image(systemName: "pause") : Image(systemName: "play") // SF Symbols
                
            }.foregroundColor(playing ? Color.orange : Color.green)
        }
    }
}

private var audioStreamIsPlaying: Bool {
    
    if let audioPlayer = player {
        return audioPlayer.rate > 0
    }
    
    return false
}

private func configureAudioSession() {
    
    do {
        try session.setCategory(AVAudioSession.Category.playback,
                                mode: .default,
                                policy: .longFormAudio,
                                options: [])
    } catch let error {
        fatalError("*** Unable to set up the audio session: \(error.localizedDescription) ***")
    }
}

private func playPauseActionHandler(completion: ((Bool)->Void)? = nil) {
    
    if player == nil {
        configureAudioSession()
    }
    
    if let url = URL(string: podcastURLstring) {
        
        playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        session.activate(options: []) { (success, error) in
            
            guard error == nil else {
                print("*** An error occurred: \(error!.localizedDescription) ***")
                completion?(false)
                return
            }
            
            if success {
                if audioStreamIsPlaying {
                    player?.pause()
                } else {
                    player?.play()
                }
            }
            
            completion?(success)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
