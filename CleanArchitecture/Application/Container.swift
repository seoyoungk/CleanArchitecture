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
        container.autoregister(Network.self, initializer: DefaultNetwork.init)
        container.autoregister(WebAPI.self, initializer: DefaultWebAPI.init)
        container.autoregister(CacheRepository.self, initializer: DefaultCacheRepository.init)

        // UseCases
        container.autoregister(MusicUseCase.self, initializer: DefaultMusicUseCase.init)

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
