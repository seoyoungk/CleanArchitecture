//
//  MusicDetailViewReactor.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/31.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import RxSwift
import ReactorKit
import RxCocoa

final class MusicDetailViewReactor: Reactor, LoadingIndicatable {
    private let musicUseCase: MusicUseCase

    var initialState: State
    var disposeBag: DisposeBag = DisposeBag()
    var loadingSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    let error: PublishSubject<String> = PublishSubject<String>()

    init(musicUseCase: MusicUseCase, music: Music) {
        self.musicUseCase = musicUseCase
        var isFavorite: Bool {
            return musicUseCase.getFavorites().contains(where: { $0.trackId == music.trackId})
        }
        self.initialState = State(isFavorite: isFavorite, music: music)

        loadingSubject
        .distinctUntilChanged()
            .map { Action.setIsLoading($0)}
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    struct State {
        var isLoading: Bool = false
        var isFavorite: Bool
        var music: Music
    }

    enum Action {
        case setIsLoading(Bool)
        case setFavorite
    }

    enum Mutation {
        case setIsLoading(Bool)
        case setFavorite
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setIsLoading(isLoading):
            return .just(.setIsLoading(isLoading))
        case .setFavorite:
            if currentState.isFavorite {
                musicUseCase.unsetFavorite(music: currentState.music)
            } else {
                musicUseCase.setFavorite(music: currentState.music)
            }
            return .just(.setFavorite)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
        case .setFavorite:
            newState.isFavorite.toggle()
        }
        return newState
    }
}
