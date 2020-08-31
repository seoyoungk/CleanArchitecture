//
//  MusicUseCase.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/25.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import RxSwift

protocol MusicUseCase: CacheRepository {
    func searchMusic(music: String) -> Observable<Resource<MusicResponse>>
}

final class DefaultMusicUseCase: MusicUseCase {
    private let api: WebAPI
    private let cacheRepository: CacheRepository

    init(api: WebAPI, cacheRepository: CacheRepository) {
        self.api = api
        self.cacheRepository = cacheRepository
    }

    // api
    func searchMusic(music: String) -> Observable<Resource<MusicResponse>> {
        return api.searchMusic(music: music)
    }

    // cache
    func getRecentSearchHistory() -> [Music] {
        return cacheRepository.getRecentSearchHistory()
    }

    func saveSearchHistory(music: Music) {
        return cacheRepository.saveSearchHistory(music: music)
    }

    func getFavorites() -> [Music] {
        return cacheRepository.getFavorites()
    }
    
    func setFavorite(music: Music) {
        return cacheRepository.setFavorite(music: music)
    }
    
    func unsetFavorite(music: Music) {
        return cacheRepository.unsetFavorite(music: music)
    }
}
