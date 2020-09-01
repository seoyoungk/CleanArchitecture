CleanArchitecture
=======
Clean Architecture Example for searching music from iTunes.

<img width="220" alt="스크린샷 2020-08-31 오후 4 07 17" src="https://user-images.githubusercontent.com/47695995/91699273-00983280-ebaf-11ea-8b77-2c06ff902512.png"> <img width="220" alt="스크린샷 2020-08-31 오후 3 20 27" src="https://user-images.githubusercontent.com/47695995/91699261-fb3ae800-ebae-11ea-87cb-e6f685e75ae9.png"> <img width="220" alt="스크린샷 2020-08-31 오후 5 31 05" src="https://user-images.githubusercontent.com/47695995/91699772-c4b19d00-ebaf-11ea-8877-9c4312b92212.png"> <img width="220" alt="스크린샷 2020-08-31 오후 4 08 01" src="https://user-images.githubusercontent.com/47695995/91699280-0261f600-ebaf-11ea-8bab-1b4f916e9513.png"> <img width="220" alt="스크린샷 2020-08-31 오후 4 07 22" src="https://user-images.githubusercontent.com/47695995/91699274-0130c900-ebaf-11ea-8714-85eb8d7123ed.png">

Architecture
-----------
- **Uni-directional hierarchy**
- Domain Layer = Entities + Use Cases + Repositories Interfaces
- Data Repositories Layer = API
- Presentation Layer = ViewModels + Views

Features
-----------
- Using ReactorKit
- Using RxDataSources
- Dependency Injection using Swinject
- Using AlamofireObjectMapper

Container
---------
Dependency Injection using Swinject

```Swift
...
container.register(Network.self) { _ in DefaultNetwork() }

container.register(MusicUseCase.self) { r in
    return DefaultMusicUseCase(api: r.resolve(WebAPI.self)!, cacheRepository: r.resolve(CacheRepository.self)!)
}
...
```

Data
------
Data include WebAPI, Network
```Swift
protocol WebAPI {
    func searchMusic(music: String) -> Observable<Resource<MusicResponse>>
}
```

UseCase
-------
Handle WebAPI, Cache in UseCase
```Swift
final class DefaultMusicUseCase: MusicUseCase {
    private let api: WebAPI
    private let cacheRepository: CacheRepository

    init(api: WebAPI, cacheRepository: CacheRepository) {
        self.api = api
        self.cacheRepository = cacheRepository
    }

    // api
    func searchMusic(music: String) -> Observable<Resource<MusicResponse>> {
        return api.searchMusic(music: music)
    }

    // cache
    func getRecentSearchHistory() -> [Music] {
        return cacheRepository.getRecentSearchHistory()
    }
    ...
```

Bind Loading
--------
By using Rx, it indicates the status of loading, one of the api responses.
```Swift
protocol LoadingRepresentable {
    var isLoading: Bool { get }
}

protocol LoadingIndicatable {
    var loadingSubject: PublishSubject<Bool> { get set }
}

extension Observable where Element: LoadingRepresentable {
    func mapLoading(_ loadingIndicatable: LoadingIndicatable) -> Observable<Element> {
        return self.do(onNext: { element in
            loadingIndicatable.loadingSubject.onNext(element.isLoading)
        })
    }
}
```
