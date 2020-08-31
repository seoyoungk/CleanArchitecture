//
//  CacheRepository.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/31.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import Disk

protocol CacheRepository {
    func getRecentSearchHistory() -> [Music]
    func saveSearchHistory(music: Music)
    func getFavorites() -> [Music]
    func setFavorite(music: Music)
    func unsetFavorite(music: Music)
}

class DefaultCacheRepository: CacheRepository {
    private var musics: [Music] {
        get {
            return getFavorites()
        }
    }

    private var histories: [Music] {
        get {
            return getRecentSearchHistory()
        }
    }

    func getRecentSearchHistory() -> [Music] {
        do {
            return try Disk.retrieve("history", from: .caches, as: [Music].self)
        } catch {
            print("error occured during retrive history")
            return []
        }
    }

    func saveSearchHistory(music: Music) {
        do {
            var histories = self.histories.filter { $0.trackId != music.trackId }
            histories.insert(music, at: 0)
            if self.histories.isEmpty {
                try Disk.append(histories, to: "history", in: .caches)
            } else {
                try Disk.save(histories, to: .caches, as: "history")
            }
        } catch {
            print("error occured during saving search history")
            return
        }
    }

    func getFavorites() -> [Music] {
        do {
            return try Disk.retrieve("music", from: .caches, as: [Music].self)
        } catch {
            print("error occured during retrive music")
            return []
        }
    }

    func setFavorite(music: Music) {
        do {
            var musics = self.musics
            musics.insert(music, at: 0)
            if self.musics.isEmpty {
                try Disk.append(musics, to: "music", in: .caches)
            } else {
                try Disk.save(musics, to: .caches, as: "music")
            }
        } catch {
            print("error occured during settting favorite music")
            return
        }
    }

    func unsetFavorite(music: Music) {
        do {
            let musics = self.musics.filter { $0.trackId != music.trackId }
            try Disk.save(musics, to: .caches, as: "music")
        } catch {
            print("error occured during unsettting favorite music")
            return
        }
    }
}
