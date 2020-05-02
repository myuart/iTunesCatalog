//
//  EntryTableViewCell.swift
//  iTunesCatalog
//
//  Created by Maria Yu on 4/30/20.
//  Copyright © 2020 Maria Yu. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    @IBOutlet var linkLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var favoriteButton: UIButton!

    var favoriteButtonAction : (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        favoriteButton.addTarget(self, action: #selector(favoriteTapped(_:)), for: .touchUpInside)
    }

    @IBAction func favoriteTapped(_ sender: UIButton) {
        guard let name = nameLabel.text, let urlString = linkLabel.text else { return }
        let key = name + "_" + urlString
        
        if let _ = UserDefaults.standard.string(forKey: key) {
            sender.setImage(UIImage(named: "unfavorite"), for: .normal)
            UserDefaults.standard.removeObject(forKey: key)
        }
        else {
            sender.setImage(UIImage(named: "favorite"), for: .normal)
            UserDefaults.standard.set(key, forKey:key)
        }
    }
    
    @IBAction func linkTapped(_ sender: UIButton) {
        guard let urlString = linkLabel.text else { return }
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
