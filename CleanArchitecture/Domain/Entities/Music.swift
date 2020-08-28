//
//  Music.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/22.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import ObjectMapper

final class MusicResponse: Music {
    var error: String?
    var message: String?

    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        error <- map["error"]
        message <- map["message"]
    }
}

class Music: Mappable {
    var trackName: String?
    var artistName: String?
    var collectionName: String?
    var artworkUrl100: String?

    required init?(map: Map) {}

    func mapping(map: Map) {
        trackName <- map["trackName"]
        artistName <- map["artistName"]
        collectionName <- map["collectionName"]
        artworkUrl100 <- map["artworkUrl100"]
    }
}
