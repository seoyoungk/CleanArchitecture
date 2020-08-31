//
//  MusicDetailViewController.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/31.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class MusicDetailViewController: BaseViewController {
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    @IBOutlet weak var btnPreview: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelArtist: UILabel!
    @IBOutlet weak var labelTrackTime: UILabel!

    var disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setMusicInfo(music: Music) {
        if let url = music.artworkUrl100, let imgUrl = URL(string: url) {
            imgView.kf.setImage(with: imgUrl)
        }
        labelTitle.text = music.trackName
        labelArtist.text = music.artistName
        labelTrackTime.text = getTrackTimeForMinute(millis: music.trackTimeMillis)
    }

    func getTrackTimeForMinute(millis: Int64) -> String {
        let seconds: Int = Int(millis/1000)
        return "\(seconds/60):\(seconds%60)"
    }
}

extension MusicDetailViewController: StoryboardView {
    typealias Reactor = MusicDetailViewReactor

    func bind(reactor: Reactor) {

        reactor.error
            .subscribe(onNext: { [weak self] error in
                self?.showErrorToast(error)
            }).disposed(by: disposeBag)

        reactor.state.map { $0.isLoading }
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.showIndicator() : self?.hideIndicator()
            }).disposed(by: disposeBag)

        reactor.state.map { $0.music }
            .subscribe(onNext: { [weak self] music in
                self?.setMusicInfo(music: music)
            }).disposed(by: disposeBag)

        reactor.state.map { $0.isFavorite ? UIImage(named: "favoriteY") : UIImage(named: "favoriteN")}
            .bind(to: btnFavorite.rx.image())
        .disposed(by: disposeBag)

        btnBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)

        btnPreview.rx.tap
            .subscribe(onNext: { _ in
                if let url = reactor.currentState.music.previewUrl, let previewUrl = URL(string: url) {
                    UIApplication.shared.open(previewUrl, options: [:], completionHandler: nil)
                }
            }).disposed(by: disposeBag)

        btnFavorite.rx.tap
            .map { Reactor.Action.setFavorite}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
