//
//  AudioRecorder.swift
//  PishiDino
//
//  Created by Amir Ali on 4/10/25.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var isRecording = false
    private var audioRecorder: AVAudioRecorder?

    func startRecording(to fileName: String) {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            // Prepare audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)

            // Create and start recorder
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()

            isRecording = true
            print("🎙️ Recording started at \(url.path)")
        } catch {
            print("❌ Failed to start recording:", error.localizedDescription)
        }
    }

    func stopRecording() {
        guard isRecording else { return }

        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false

        do {
            try AVAudioSession.sharedInstance().setActive(false)
            print("🛑 Recording stopped")
        } catch {
            print("⚠️ Failed to deactivate audio session:", error.localizedDescription)
        }
    }
}

