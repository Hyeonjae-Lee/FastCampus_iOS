//
//  TrackManager.swift
//  AppleMusicStApp
//
//  Created by joonwon lee on 2020/01/12.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import AVFoundation

class TrackManager {
    // TODO: 프로퍼티 정의하기 - 트랙들, 앨범들, 오늘의 곡
    var tracks: [AVPlayerItem] = []
    var album: [Album] = []
    var todaysTrack: AVPlayerItem?
    // TODO: 생성자 정의하기
    init() {
        //let palyItem = AVPlayerItem(url: <#T##URL#>)
        let tracks = loadTracks()
        self.tracks = tracks
        self.album = loadAlbums(tracks: tracks)
        self.todaysTrack = self.tracks.randomElement()//랜덤으로 하나를 가지고온다.
    }

    // TODO: 트랙 로드하기
    func loadTracks() -> [AVPlayerItem] {
        //파일을 읽어서 avPlayer만들기
        //bundle은 앱 내에서 기본적으로 제공해주는
        //앱 안에 있는 모든 mp3파일을 가지고 와라
        let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) ?? []
        
//        var items: [AVPlayerItem] = []
//
//        for url in urls {
//            let item = AVPlayerItem(url: url)
//            items.append(item)
//        }
        
//        let items = urls.map { url -> AVPlayerItem in
//            let item = AVPlayerItem(url: url)
//            return item
//        }
        
//        let items = urls.map { url in
//            return AVPlayerItem(url: url)
//        }
  
        let items = urls.map { AVPlayerItem(url: $0) }
        
        return items
    }
    
    // TODO: 인덱스에 맞는 트랙 로드하기
    func track(at index: Int) -> Track? {
        let playerItem = tracks[index]  
        return playerItem.convertToTrack()
    }

    // TODO: 앨범 로딩메소드 구현
    func loadAlbums(tracks: [AVPlayerItem]) -> [Album] {
        let trackList: [Track] = tracks.compactMap { $0.convertToTrack()}
        let albumDics = Dictionary(grouping: trackList, by: { (track) in track.albumName })
        var albums: [Album] = []
        for (key, value) in albumDics {
            let title = key
            let tracks = value
            let album = Album(title: title, tracks: tracks)
            albums.append(album)
        }
        
        return albums
    }

    // TODO: 오늘의 트랙 랜덤으로 선책
    func loadOtherTodaysTrack() {
        self.todaysTrack = self.tracks.randomElement()//랜덤으로 하나를 가지고온다.
    }
}
