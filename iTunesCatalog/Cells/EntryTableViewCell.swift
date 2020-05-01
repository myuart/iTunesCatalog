//
//  EntryTableViewCell.swift
//  iTunesCatalog
//
//  Created by Maria Yu on 4/30/20.
//  Copyright © 2020 Maria Yu. All rights reserved.
//

import UIKit

let favoriteCache = NSCache<AnyObject, AnyObject>()

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
        guard let urlString = linkLabel.text else { return }
        
        if let _ = favoriteCache.object(forKey: urlString as AnyObject) {
            favoriteCache.removeObject(forKey: urlString as AnyObject)
            sender.setImage(UIImage(named: "unfavorite"), for: .normal)
        }
        else {
            favoriteCache.setObject(urlString as AnyObject, forKey: urlString as AnyObject)
            sender.setImage(UIImage(named: "favorite"), for: .normal)
        }
    }
    
    @IBAction func linkTapped(_ sender: UIButton) {
        guard let urlString = linkLabel.text else { return }
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}
