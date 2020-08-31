//
//  Container.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/27.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import Swinject
import SwinjectAutoregistration

final class MusicContainer {
    static var shared: Container {
        let container: Container = Container()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

        // Services
        container.register(Network.self) { _ in DefaultNetwork() }
        container.register(WebAPI.self) { r in DefaultWebAPI(network: r.resolve(Network.self)!) }
        container.register(CacheRepository.self) { r in DefaultCacheRepository() }

        // UseCases
        container.register(MusicUseCase.self) { r in
            return DefaultMusicUseCase(api: r.resolve(WebAPI.self)!, cacheRepository: r.resolve(CacheRepository.self)!)
        }

        // Views
        container.register(HomeViewController.self) { r in
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            vc.reactor = HomeViewReactor(musicUseCase: r.resolve(MusicUseCase.self)!)
            return vc
        }

        container.register(FavoriteViewController.self) { r in
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "FavoriteViewController") as! FavoriteViewController
            vc.reactor = FavoriteViewReactor(musicUseCase: r.resolve(MusicUseCase.self)!)
            return vc
        }

        container.register(MusicDetailViewController.self) { (r, music: Music) in
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "MusicDetailViewController") as! MusicDetailViewController
            vc.reactor = MusicDetailViewReactor(musicUseCase: r.resolve(MusicUseCase.self)!, music: music)
            return vc
        }

        return container
    }
}
