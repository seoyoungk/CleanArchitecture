//
//  observable+Extension.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/28.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import RxSwift
import ReactorKit

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
