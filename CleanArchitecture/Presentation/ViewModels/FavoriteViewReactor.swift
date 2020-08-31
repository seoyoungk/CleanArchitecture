//
//  FavoriteViewReactor.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/31.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import RxSwift
import ReactorKit
import RxCocoa

final class FavoriteViewReactor: Reactor {
    var initialState: State
    private let musicUseCase: MusicUseCase

    init(musicUseCase: MusicUseCase) {
        self.musicUseCase = musicUseCase
        self.initialState = State()
    }

    struct State {
        var musics: [Music] = []
    }

    enum Action {
        case getFavorites
    }

    enum Mutation {
        case setFavorites
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getFavorites:
            return .just(.setFavorites)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setFavorites:
            newState.musics = musicUseCase.getFavorites()
        }
        return newState
    }
}
