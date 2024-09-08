//
//  ContentView.swift
//  MetalPetal HDR Playground
//
//  Created by Zachary Gibson on 9/8/24.
//

import AVKit
import MetalPetal
import SwiftUI

struct ContentView: View {
    @State private var colorPrimary = 0
    @State private var colorTransferFunction = 0
    @State private var colorMatrix = 0
    var nonMetalPetalPlayer: AVPlayer? {
        guard let videoURL = Bundle.main.url(forResource: "hdr-test", withExtension: "MOV") else {
            return nil
        }
        
        let player = AVPlayer(url: videoURL)
        player.play()
        return player
    }
    
    var body: some View {
        VStack {
            VideoPlayer(player: FilteredVideoPlayer.shared.player)
                .onAppear {
                    loadVideo()
                }
            Picker("Color Primary", selection: $colorPrimary) {
                Text("P3_D65").tag(0)
                Text("SMPTE_C").tag(1)
                Text("ITU_R_2020").tag(2)
                Text("ITU_R_709_2").tag(3)
            }
            .pickerStyle(.segmented)
            .padding()
            Picker("Color Transfer", selection: $colorTransferFunction) {
                Text("Linear").tag(0)
                Text("ITU_R_709_2").tag(1)
                Text("ITU_R_2100_HLG").tag(2)
                Text("SMPTE_ST_2084_PQ").tag(3)
            }
            .pickerStyle(.segmented)
            .padding()
            Picker("Color Matrix", selection: $colorMatrix) {
                Text("ITU_R_2020").tag(0)
                Text("ITU_R_601_4").tag(1)
                Text("ITU_R_709_2").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
        }
        .onChange(of: colorPrimary) { oldValue, newValue in
            if newValue == 0 {
                FilteredVideoPlayer.shared.colorPrimaries = AVVideoColorPrimaries_P3_D65
            }
            if newValue == 1 {
                FilteredVideoPlayer.shared.colorPrimaries = AVVideoColorPrimaries_SMPTE_C
            }
            if newValue == 2 {
                FilteredVideoPlayer.shared.colorPrimaries = AVVideoColorPrimaries_ITU_R_2020
            }
            if newValue == 3 {
                FilteredVideoPlayer.shared.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2
            }
            
            FilteredVideoPlayer.shared.updateVideoComposition()
        }
        .onChange(of: colorTransferFunction) { oldValue, newValue in
            if newValue == 0 {
                FilteredVideoPlayer.shared.colorTransferFunction = AVVideoTransferFunction_Linear
            }
            if newValue == 1 {
                FilteredVideoPlayer.shared.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2
            }
            if newValue == 2 {
                FilteredVideoPlayer.shared.colorTransferFunction = AVVideoTransferFunction_ITU_R_2100_HLG
            }
            if newValue == 3 {
                FilteredVideoPlayer.shared.colorTransferFunction = AVVideoTransferFunction_SMPTE_ST_2084_PQ
            }
            
            FilteredVideoPlayer.shared.updateVideoComposition()
        }
        .onChange(of: colorMatrix) { oldValue, newValue in
            if newValue == 0 {
                FilteredVideoPlayer.shared.colorMatrix = AVVideoYCbCrMatrix_ITU_R_2020
            }
            if newValue == 1 {
                FilteredVideoPlayer.shared.colorMatrix = AVVideoYCbCrMatrix_ITU_R_601_4
            }
            if newValue == 2 {
                FilteredVideoPlayer.shared.colorMatrix = AVVideoYCbCrMatrix_ITU_R_709_2
            }
            
            FilteredVideoPlayer.shared.updateVideoComposition()
        }
    }
    
    func loadVideo() {
        if let videoURL = Bundle.main.url(forResource: "hdr-test", withExtension: "MOV") {
            FilteredVideoPlayer.shared.configure(videoURL: videoURL)
        }
    }
}

#Preview {
    ContentView()
}
