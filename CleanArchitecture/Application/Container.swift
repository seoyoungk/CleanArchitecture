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

        // UseCases
        container.register(MusicUseCase.self) { r in
            return DefaultMusicUseCase(api: r.resolve(WebAPI.self)!)
        }

        // Views
        container.register(HomeViewController.self) { r in
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            vc.reactor = HomeViewReactor(musicUseCase: r.resolve(MusicUseCase.self)!)
            return vc
        }

        return container
    }
}
