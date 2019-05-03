//
//  RTSPViewController.swift
//  RTSP
//
//  Created by Daniel on 2018/12/12.
//  Copyright © 2018年 Daniel. All rights reserved.
//

import UIKit

class RTSPViewController: UIViewController {

    @IBOutlet private weak var playerView: UIView!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    let player = VLCMediaListPlayer()
    
    var rtspUrlStringArray: [String] = ["http://streams.videolan.org/streams/mp4/Mr_MrsSmith-h264_aac.mp4","https://www.radiantmediaplayer.com/media/bbb-360p.mp4","http://www.html5videoplayer.net/videos/toystory.mp4"]
    
    var changeSliderPosition = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMediaPlayer()
    }
    
    // MARK: Method
    private func configureMediaPlayer() {
        
        var list = [VLCMedia]()
        for urlString in rtspUrlStringArray {
            if let url = URL(string: urlString) {
                let media = VLCMedia(url: url)
                list.append(media)
            } else {
                print("The url is invalid: \(urlString)")
            }
        }
        
        if list.count > 0 {
            player.mediaList = VLCMediaList(array: list)
            player.mediaList.delegate = self
            player.mediaPlayer.delegate = self
            player.mediaPlayer.drawable = playerView
        } else {
            print("error")
        }
    }

    fileprivate func updateTime() {
        currentTimeLabel.text = player.mediaPlayer.time.stringValue
        totalTimeLabel.text = player.mediaPlayer.media.length.stringValue
        
        if changeSliderPosition {
            let currentTime = Float(player.mediaPlayer.time.intValue)
            let totalTime = Float(player.mediaPlayer.media.length.intValue)
            slider.value = currentTime / totalTime
        }
    }
    
    // MARK: Event Handler
    @IBAction private func playPauseButtonPress(_ sender: UIButton) {
        if player.mediaPlayer.isPlaying {
            player.pause()
            playPauseButton.setTitle("播放", for: .normal)
        } else {
            player.play()
            playPauseButton.setTitle("暫停", for: .normal)
        }
    }
    
    @IBAction private func nextButtonPress(_ sender: UIButton) {
        let isNext = player.next
        if !isNext {
            // 在最後一首點下一首，會從第一首開始播放
            print("This is the last")
        }
    }
    
    @IBAction private func previousButtonPress(_ sender: UIButton) {
        let previous = player.previous
        if !previous {
            // 在第一首點上一首，會重新播放第一首
            print("This is the first")
        }
    }
    
    @IBAction private func touchDown(_ sender: UISlider) {
        print("touchDown: \(sender.value)")
        changeSliderPosition = false
    }
    
    @IBAction private func sliderValueChange(_ sender: UISlider) {
        print("sliderValueChange: \(sender.value)")
        slider.isContinuous = false
        player.mediaPlayer.position = sender.value
        changeSliderPosition = true
    }
}

extension RTSPViewController: VLCMediaDelegate {
    func mediaMetaDataDidChange(_ aMedia: VLCMedia) {
        print("mediaMetaDataDidChange")
    }
    
    func mediaDidFinishParsing(_ aMedia: VLCMedia) {
        print("mediaDidFinishParsing")
    }
}

extension RTSPViewController: VLCMediaPlayerDelegate {
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        print("mediaPlayerStateChanged: \(player.mediaPlayer.state)")
        
        switch player.mediaPlayer.state {
        case .buffering:
            indicator.startAnimating()
            print("buffering")
            break
        case .ended:
            indicator.stopAnimating()
            print("ended")
            break
        case .error:
            print("error")
            break
        case .esAdded:
            print("esAdded")
            break
        case .opening:
            print("opening")
            break
        case .paused:
            indicator.stopAnimating()
            print("paused")
            break
        case .playing:
            indicator.startAnimating()
            print("playing")
            break
        case .stopped:
            indicator.stopAnimating()
            print("stopped")
            break
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        indicator.stopAnimating()
        if player.mediaPlayer.isPlaying {
            updateTime()
        }
    }
    
    func mediaPlayerTitleChanged(_ aNotification: Notification!) {
        print("mediaPlayerTitleChanged")
    }
    
    func mediaPlayerChapterChanged(_ aNotification: Notification!) {
        print("mediaPlayerChapterChanged")
    }
    
    func mediaPlayerSnapshot(_ aNotification: Notification!) {
        print("mediaPlayerSnapshot")
    }
}


extension RTSPViewController: VLCMediaListDelegate {
    func mediaList(_ aMediaList: VLCMediaList!, mediaAdded media: VLCMedia!, at index: UInt) {
        print("mediaAdded at index: \(index)")
    }
    
    func mediaList(_ aMediaList: VLCMediaList!, mediaRemovedAt index: UInt) {
        print("mediaRemovedAt at index: \(index)")
    }
}
