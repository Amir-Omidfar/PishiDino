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
    @State private var isPlaying = false

    var body: some View {
            HStack {
                Button(action: {
                    if isPlaying {
                        pauseAudio()
                    } else {
                        playAudio()
                    }
                }) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.blue)
                }

                Button(action: {
                    stopAudio()
                }) {
                    Image(systemName: "stop.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.red)
                }
            }
            .onDisappear {
                stopAudio()
            }
        }

    private func playAudio() {
            guard let url = getAudioFileURL(fileName: audioFileName) else {
                print("⚠️ Audio file not found.")
                return
            }

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
                isPlaying = true

                // Optional: observe when playback finishes
                audioPlayer?.delegate = AudioPlayerDelegate(isPlaying: $isPlaying)
            } catch {
                print("❌ Failed to play audio: \(error.localizedDescription)")
            }
        }
    
    private func pauseAudio() {
            audioPlayer?.pause()
            isPlaying = false
        }

    private func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }

    private func getAudioFileURL(fileName: String) -> URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    }
}


// MARK: - Delegate Helper
class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
    @Binding var isPlaying: Bool

    init(isPlaying: Binding<Bool>) {
        _isPlaying = isPlaying
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
    }
}
