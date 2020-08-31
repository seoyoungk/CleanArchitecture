//
//  Music.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/22.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import ObjectMapper

final class MusicResponse: Music {
    var resultCount: Int = 0
    var results: [Music] = []
    var error: String?
    var message: String?

    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        resultCount <- map["resultCount"]
        results <- map["results"]
        error <- map["error"]
        message <- map["message"]
    }
}

enum MusicKind: String, Codable {
    case Song = "song"
    case Album = "album"
    case MusicVideo = "music-video"
    case FeatureMovie = "feature-movie"
    case Book = "book"
    case Podcast = "podcast"
    case TVEpisode = "tv-episode"
    case PodcastEpisode = "podcast-episode"
    case CoachedAudio = "coached-audio"
    case Booklet = "interactive-booklet"
    case PDF = "pdf"
    case SoftwarePackage = "software-package"
    case ETC = "etc"

    func filterETC() -> MusicKind {
        switch self {
        case .FeatureMovie, .Book, .Podcast, .TVEpisode, .PodcastEpisode, .CoachedAudio, .Booklet, .PDF, .SoftwarePackage, .ETC:
            return .ETC
        default:
            return self
        }
    }
}

class Music: Mappable, Codable {
    var trackId: Int64 = 0
    var trackName: String?
    var artistName: String?
    var collectionName: String?
    var artworkUrl100: String?
    var previewUrl: String?
    var trackTimeMillis: Int64 = 0
    var kind: MusicKind = .Song

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        trackId <- map["trackId"]
        trackName <- map["trackName"]
        artistName <- map["artistName"]
        collectionName <- map["collectionName"]
        artworkUrl100 <- map["artworkUrl100"]
        previewUrl <- map["previewUrl"]
        trackTimeMillis <- map["trackTimeMillis"]
        kind <- map["kind"]
    }
}
