//
//  HomeViewReactor.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/27.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import RxSwift
import ReactorKit
import RxCocoa

final class HomeViewReactor: Reactor, LoadingIndicatable {
    private let musicUseCase: MusicUseCase

    var initialState: State
    var disposeBag: DisposeBag = DisposeBag()
    var loadingSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    let error: PublishSubject<String> = PublishSubject<String>()

    init(musicUseCase: MusicUseCase) {
        self.musicUseCase = musicUseCase
        self.initialState = State()

        loadingSubject
        .distinctUntilChanged()
            .map { Action.setIsLoading($0)}
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    struct State {
        var isLoading: Bool = false
        var isSearching: Bool = false
        var music: Music?
    }

    enum Action {
        case setIsLoading(Bool)
        case setEmptyInput
        case searchMusic(String)
    }

    enum Mutation {
        case setIsLoading(Bool)
        case setEmptyInput
        case setMusic(Music)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setIsLoading(isLoading):
            return .just(.setIsLoading(isLoading))
        case .setEmptyInput:
            return .just(.setEmptyInput)
        case let .searchMusic(music):
            return musicUseCase.searchMusic(music: music)
                .mapLoading(self)
                .flatMap { resource -> Observable<Mutation> in
                    switch resource {
                    case let .Success(data):
                        return .just(.setMusic(data))
                    case let .Failure(error):
                        self.error.onNext(error?.message ?? "오류가 발생했습니다.")
                        return .empty()
                    default:
                        return .empty()
                    }
            }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
        case .setEmptyInput:
            newState.isSearching = false
        case let .setMusic(music):
            newState.isSearching = true
            newState.music = music
        }
        return newState
    }
}
