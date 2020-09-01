//
//  FavoriteCell.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/31.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import ReactorKit

class FavoriteCell: UICollectionViewCell, StoryboardView {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelArtist: UILabel!

    var disposeBag: DisposeBag = DisposeBag()
    typealias Reactor = MusicCellReactor

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func bind(reactor: MusicCellReactor) {

        reactor.state.map { $0.music.artworkUrl100 }
            .subscribe(onNext: { [weak self] artworkUrl in
                if let url = artworkUrl, let imgUrl = URL(string: url) {
                    self?.imgView?.kf.setImage(with: imgUrl)
                }
            }).disposed(by: disposeBag)

        reactor.state.map { $0.music.trackName }
            .bind(to: labelTitle.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map { $0.music.artistName }
            .bind(to: labelArtist.rx.text)
            .disposed(by: disposeBag)
    }
}
