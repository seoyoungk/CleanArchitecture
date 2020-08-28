//
//  MusicUseCase.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/25.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import RxSwift

protocol MusicUseCase {
    func searchMusic(music: String) -> Observable<Resource<MusicResponse>>
}

final class DefaultMusicUseCase: MusicUseCase {
    private let api: WebAPI

    init(api: WebAPI) {
        self.api = api
    }

    func searchMusic(music: String) -> Observable<Resource<MusicResponse>> {
        return api.searchMusic(music: music)
    }
}
