//
//  MusicCellReactor.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/09/02.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import RxSwift
import ReactorKit

final class MusicCellReactor: Reactor {
    var initialState: State
    typealias Action = NoAction

    struct State {
        var music: Music
    }

    init(music: Music) {
        self.initialState = State(music: music)
    }
}
