//
//  WebApi.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/22.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import RxSwift
import Alamofire

protocol WebAPI {
    func searchMusic(music: String) -> Observable<Resource<MusicResponse>>
}

final class DefaultWebAPI: WebAPI {
    let network: Network

    init(network: Network) {
        self.network = network
    }

    func searchMusic(music: String) -> Observable<Resource<MusicResponse>> {
        let params: [String: Any] = ["term": music]
        return network.get("https://itunes.apple.com/search", parameters: params, responseType: MusicResponse.self)
    }
}
