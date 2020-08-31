//
//  FavoriteViewController.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/27.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import ReactorKit

class FavoriteViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reactor?.action.onNext(.getFavorites)
    }
}

extension FavoriteViewController: StoryboardView {
    typealias Reactor = FavoriteViewReactor

    func bind(reactor: FavoriteViewReactor) {

        reactor.state.map { $0.musics }
            .bind(to: collectionView.rx.items(cellIdentifier: "FavoriteCell", cellType: FavoriteCell.self)) { (_, item, cell) in
                cell.setMusicInfo(item)
        }.disposed(by: disposeBag)

        collectionView.rx.modelSelected(Music.self)
        .subscribe(onNext: { [weak self] item in
            if let vc = MusicContainer.shared.resolve(MusicDetailViewController.self, argument: item) {
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)

        collectionView.rx.didEndDisplayingCell
        .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.snp.updateConstraints { make in
                make.height.equalTo(self.collectionView.contentSize)
            }
        }).disposed(by: disposeBag)

        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = UIScreen.main.bounds.width - 80
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: widthPerItem * 1.8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}
