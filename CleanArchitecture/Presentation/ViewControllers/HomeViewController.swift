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
import RxDataSources

class HomeViewController: BaseViewController, UIScrollViewDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewResultCount: UIView!
    @IBOutlet weak var labelResultCount: UILabel!

    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.setEmptyInput)
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

        reactor.state.map { $0.resultCount }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] count in
                self?.labelResultCount.text = "검색 결과 : \(count)개"
            }).disposed(by: disposeBag)

        reactor.state.map { !$0.isSearching }
            .bind(to: viewResultCount.rx.isHidden)
            .disposed(by: disposeBag)

        let musicInfoDataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, MusicInfo>>(configureCell: { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as! MusicCell
            switch item {
            case let .RecentSearchHistory(history):
                cell.setMusicInfo(history)
            case let .Song(song):
                cell.setMusicInfo(song)
            case let .Album(album):
                cell.setMusicInfo(album)
            case let .MusicVideo(mv):
                cell.setMusicInfo(mv)
            case let .ETC(etc):
                cell.setMusicInfo(etc)
            }
            return cell
        }, titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].model
        })

        reactor.state.map { $0.musicInfoSections }
            .bind(to: tableView.rx.items(dataSource: musicInfoDataSource))
        .disposed(by: disposeBag)

        tableView.rx.modelSelected(MusicInfo.self)
            .subscribe(onNext: { [weak self] item in
                if let vc = MusicContainer.shared.resolve(MusicDetailViewController.self, argument: item.getMusicInfo()) {
                    reactor.action.onNext(.saveHistory(item.getMusicInfo()))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
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
