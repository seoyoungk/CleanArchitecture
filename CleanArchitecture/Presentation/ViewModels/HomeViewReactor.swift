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
import RxDataSources

enum MusicInfo {
    case RecentSearchHistory(Music)
    case Song(Music)
    case Album(Music)
    case MusicVideo(Music)
    case ETC(Music)

    func getMusicInfo() -> Music {
        switch self {
        case .RecentSearchHistory(let history):
            return history
        case .Song(let song):
            return song
        case .Album(let album):
            return album
        case .MusicVideo(let mv):
            return mv
        case .ETC(let etc):
            return etc
        }
    }
}

final class HomeViewReactor: Reactor, LoadingIndicatable {
    private let musicUseCase: MusicUseCase

    var initialState: State
    var disposeBag: DisposeBag = DisposeBag()
    var loadingSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    let error: PublishSubject<String> = PublishSubject<String>()

    init(musicUseCase: MusicUseCase) {
        self.musicUseCase = musicUseCase

        self.initialState = State(musicInfoSections: [], histories: musicUseCase.getRecentSearchHistory())

        loadingSubject
        .distinctUntilChanged()
            .map { Action.setIsLoading($0)}
            .bind(to: action)
            .disposed(by: disposeBag)
    }

    struct State {
        var isLoading: Bool = false
        var isSearching: Bool = false
        var musicInfoSections: [SectionModel<String, MusicInfo>]
        var musics: [Music] = []
        var histories: [Music] = []
        var resultCount: Int = 0
    }

    enum Action {
        case setIsLoading(Bool)
        case setEmptyInput
        case searchMusic(String)
        case saveHistory(Music)
    }

    enum Mutation {
        case setIsLoading(Bool)
        case setEmptyInput
        case setMusic(MusicResponse)
        case setRecentSearchHistory
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
        case let .saveHistory(music):
            musicUseCase.saveSearchHistory(music: music)
            return .just(.setRecentSearchHistory)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setIsLoading(isLoading):
            newState.isLoading = isLoading
        case .setEmptyInput:
            newState.isSearching = false
            newState.musicInfoSections = setRecentSearchInfoSections()
        case let .setMusic(data):
            newState.isSearching = true
            newState.resultCount = data.resultCount
            newState.musics = data.results
            newState.musicInfoSections = data.setMusicInfoSections()
        case .setRecentSearchHistory:
            newState.histories = musicUseCase.getRecentSearchHistory()
        }
        return newState
    }

    func setRecentSearchInfoSections() -> [SectionModel<String, MusicInfo>] {
        let recentSearchHistoryInfo = currentState.histories.map { MusicInfo.RecentSearchHistory($0) }
        let recentSearchHistoryInfoSection = SectionModel<String, MusicInfo>(model: "최근 검색 기록", items: recentSearchHistoryInfo)
        return [recentSearchHistoryInfoSection]
    }
}

fileprivate extension MusicResponse {
    func setMusicInfoSections() -> [SectionModel<String, MusicInfo>] {
        let songs = self.results.filter { $0.kind == .Song }
        let songInfo = songs.map { MusicInfo.Song($0) }
        let songInfoSection = SectionModel<String, MusicInfo>(model: "노래", items: songInfo)

        let albums = self.results.filter { $0.kind == .Album }
        let albumInfo = albums.map { MusicInfo.Album($0) }
        let albumInfoSection = SectionModel<String, MusicInfo>(model: "앨범", items: albumInfo)

        let musicVideos = self.results.filter { $0.kind == .MusicVideo }
        let musicVideosInfo = musicVideos.map { MusicInfo.MusicVideo($0) }
        let musicVideosInfoSection = SectionModel<String, MusicInfo>(model: "뮤직 비디오", items: musicVideosInfo)

        let ETC = self.results.filter { $0.kind.filterETC() == .ETC }
        let ETCInfo = ETC.map { MusicInfo.ETC($0) }
        let ETCInfoSection = SectionModel<String, MusicInfo>(model: "기타", items: ETCInfo)

        return [songInfoSection, albumInfoSection, musicVideosInfoSection, ETCInfoSection].filter { !$0.items.isEmpty }
    }
}
