//
//  FilteredVideoPlayer.swift
//  MetalPetal HDR Playground
//
//  Created by Zachary Gibson on 9/8/24.
//

import AVKit
import MetalPetal

@Observable class FilteredVideoPlayer {
    static var shared: FilteredVideoPlayer = FilteredVideoPlayer()
    
    let player: AVPlayer
    var videoURL: URL = URL(fileURLWithPath: "")
    var colorPrimaries: String?
    var colorTransferFunction: String?
    var colorMatrix: String?
    
    private init() {
        self.player = AVPlayer()
    }
    
    func configure(videoURL: URL) {
        self.videoURL = videoURL
        updateVideoComposition()
    }
    
    func updateVideoComposition() {
        if let defaultDevice = MTLCreateSystemDefaultDevice() {
            do {
                let options = MTIContextOptions()
                options.workingPixelFormat = .bgr10_xr
                let renderContext = try MTIContext(device: defaultDevice, options: options)
                let playerItem = AVPlayerItem(url: videoURL)
                let composition = MTIVideoComposition(
                    asset: playerItem.asset,
                    context: renderContext,
                    queue: DispatchQueue.main,
                    filter: { request in
                        return request.anySourceImage ?? MTIImage.black
                    }
                )
                
                composition.colorPrimaries = colorPrimaries
                composition.colorTransferFunction = colorTransferFunction
                composition.colorYCbCrMatrix = colorMatrix
                
                playerItem.videoComposition = composition.makeAVVideoComposition()
                player.replaceCurrentItem(with: playerItem)
                player.allowsExternalPlayback = false
                player.isMuted = true
                player.play()
                
            } catch {
                // TODO: Handle error, possibly logging it
                print("Error creating MTIContext or AVVideoComposition")
            }
        } else {
            // TODO: Handle error, possibly logging it
            print("Metal is not supported on this device")
        }
    }
}


