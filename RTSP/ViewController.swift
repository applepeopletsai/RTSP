//
//  ViewController.swift
//  RTSP
//
//  Created by Daniel on 2018/12/11.
//  Copyright © 2018年 Daniel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let p: VLCMediaPlayer = {
       return VLCMediaPlayer()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(v)
        v.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        v.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        v.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        v.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        v.backgroundColor = UIColor.black
        
        let url = URL(string: "rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov")
//        let url = URL(string: "rtsp://184.72.239.149/vod/mp4:BigBuckBunny_175k.mov")
        let media = VLCMedia(url: url!)
        
        p.media = media
        p.media.delegate = self
        p.delegate = self
        p.drawable = v
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        p.play()
    }
}

extension ViewController: VLCMediaDelegate {
    func mediaDidFinishParsing(_ aMedia: VLCMedia) {
        print("mediaDidFinishParsing")
    }
    
    func mediaMetaDataDidChange(_ aMedia: VLCMedia) {
        print("mediaMetaDataDidChange")
    }
}

extension ViewController: VLCMediaPlayerDelegate {
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        print("mediaPlayerStateChanged")
        
        if let v = aNotification.object as? VLCMediaPlayer {
            print("willPlay: \(v.willPlay)")
            print("isPlaying: \(v.isPlaying)")
            print("isSeekable: \(v.isSeekable)")
            
            switch v.state {
            case .buffering:
                print("buffering")
                break
            case .ended:
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
                print("paused")
                break
            case .playing:
                print("playing")
                break
            case .stopped:
                print("stopped")
                break
            }
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        print("mediaPlayerTimeChanged")
        
        if let v = aNotification.object as? VLCMediaPlayer {
            print("willPlay: \(v.willPlay)")
            print("isPlaying: \(v.isPlaying)")
            print("isSeekable: \(v.isSeekable)")
            print("length: \(v.media.length)")
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
