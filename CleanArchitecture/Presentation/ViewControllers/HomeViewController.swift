//
//  HomeViewController.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/27.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension HomeViewController: StoryboardView {
    typealias Reactor = HomeViewReactor

    func bind(reactor: HomeViewReactor) {

        reactor.error
            .subscribe(onNext: { [weak self] error in
                self?.showErrorToast(error)
            }).disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.showIndicator() : self?.hideIndicator()
            }).disposed(by: disposeBag)

        searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { $0.isEmpty ? Reactor.Action.setEmptyInput : Reactor.Action.searchMusic($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
