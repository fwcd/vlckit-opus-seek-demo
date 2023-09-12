//
//  ContentView.swift
//  VLCKitOpusSeekDemo
//
//  Created on 12.09.23
//

import SwiftUI
import MobileVLCKit

extension Double {
    init(secondsFrom vlcTime: VLCTime) {
        self = Double(vlcTime.intValue) / 1000
    }
}

extension VLCTime {
    convenience init(fromSeconds seconds: Double) {
        self.init(int: Int32(seconds * 1000))
    }
}

private class ViewModel: NSObject, ObservableObject, VLCMediaPlayerDelegate {
    @Published var isPlaying: Bool = false
    @Published var time: Double = 0
    @Published var duration: Double = 0
    let player = VLCMediaPlayer()
    
    override init() {
        super.init()
        let url = Bundle.main.url(forResource: "ehren-paper_lights-96", withExtension: "opus")!
        player.media = VLCMedia(url: url)
        player.delegate = self
    }
    
    func mediaPlayerStateChanged(_ aNotification: Notification) {
        isPlaying = player.isPlaying
        duration = Double(secondsFrom: player.media!.length)
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification) {
        time = Double(secondsFrom: player.time)
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("\(viewModel.time)")
                Slider(value: $viewModel.time, in: 0...viewModel.duration) { _ in
                    viewModel.player.time = VLCTime(fromSeconds: viewModel.time)
                }
            }
            HStack {
                Button {
                    viewModel.player.jumpBackward(10)
                } label: {
                    Image(systemName: "gobackward.10")
                }
                Button {
                    if viewModel.isPlaying {
                        viewModel.player.pause()
                    } else {
                        viewModel.player.play()
                    }
                } label: {
                    if viewModel.isPlaying {
                        Image(systemName: "pause")
                    } else {
                        Image(systemName: "play")
                    }
                }
                Button {
                    viewModel.player.jumpForward(10)
                } label: {
                    Image(systemName: "goforward.10")
                }
            }
            .font(.system(size: 24))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
