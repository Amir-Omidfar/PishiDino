//
//  AudioPlayerView.swift
//  PishiDino
//
//  Created by Amir Ali on 4/10/25.
//

import SwiftUI
import AVFoundation

struct AudioPlayerView: View {
    let audioFileName: String
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: playAudio) {
                Label("Play Voice Memo", systemImage: "play.circle.fill")
            }
        }
        .padding()
    }

    func playAudio() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(audioFileName)
        
        print("🔊 Attempting to play from: \(url.path)")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error)")
        }
    }
}
