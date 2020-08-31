//
//  FavoriteCell.swift
//  CleanArchitecture
//
//  Created by Seoyoung on 2020/08/31.
//  Copyright © 2020 Seoyoung. All rights reserved.
//

import UIKit
import Kingfisher

class FavoriteCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelArtist: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setMusicInfo(_ music: Music) {
        if let url = music.artworkUrl100, let imgUrl = URL(string: url) {
            imgView.kf.setImage(with: imgUrl)
        }
        labelTitle.text = music.trackName
        labelArtist.text = music.artistName
    }
}
