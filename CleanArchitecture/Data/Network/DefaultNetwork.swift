//
//  DefaultNetwork.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/22.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import RxSwift
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

struct ErrorType {
    var error: String?
    var message: String?
}

protocol LoadingRepresentable {
    var isLoading: Bool { get }
}

enum Resource<T>: LoadingRepresentable {
    case Loading
    case Success(T)
    case Failure(ErrorType?)

    var isLoading: Bool {
        if case .Loading = self {
            return true
        } else {
            return false
        }
    }

    func getData() -> T? {
        switch self {
        case .Loading:
            return nil
        case let .Success(data):
            return data
        case .Failure:
            return nil
        }
    }
}

protocol Network {
    func get<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>>
    func post<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>>
}

extension Network {
    func get<T: Mappable>(_ path: String, responseType: T.Type) -> Observable<Resource<T>> {
        return get(path, parameters: nil, responseType: T.self)
    }

    func post<T: Mappable>(_ path: String, responseType: T.Type) -> Observable<Resource<T>> {
        return post(path, parameters: nil, responseType: T.self)
    }
}

final class DefaultNetwork: Network {
    private func request<T: Mappable>(_ path: String, method: HTTPMethod, parameters: Parameters?, responseType: T.Type) -> Observable<Resource<T>> {
        return Observable.create { observer in
            observer.onNext(Resource.Loading)
            Alamofire.request("\(path)", method: method, parameters: parameters).responseObject { (response: DataResponse<T>) in
                guard response.result.isSuccess, let json = response.value else {
                    observer.onNext(Resource.Failure(response.value as? ErrorType))
                    observer.onCompleted()
                    return
                }
                observer.onNext(Resource.Success(json))
                observer.onCompleted()
                return
            }
            return Disposables.create()
        }
        .observeOn(MainScheduler.asyncInstance)
    }

    func get<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>> {
        return request(path, method: .get, parameters: parameters, responseType: T.self)
    }
    
    func post<T: Mappable>(_ path: String, parameters: [String: Any]?, responseType: T.Type) -> Observable<Resource<T>> {
        return request(path, method: .post, parameters: parameters, responseType: T.self)
    }
}
