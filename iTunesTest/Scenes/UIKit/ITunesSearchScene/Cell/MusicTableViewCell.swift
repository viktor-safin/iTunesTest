//
//  MusicTableViewCell.swift
//  iTunesTest
//
//  Created by Виктор on 03.03.2024.
//

import UIKit

struct MusicData: Identifiable {
    var id = UUID()
    let artistName: String
    let collectionName: String
    let trackName: String
    let imageURL: String
    let trackURL: String

}

final class MusicTableViewCell: UITableViewCell {

    @IBOutlet private weak var ibImageView: UIImageView!
    
    @IBOutlet private weak var ibLabel1: UILabel!
    @IBOutlet private weak var ibLabel2: UILabel!
    @IBOutlet private weak var ibLabel3: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        ibImageView.image = nil
        ibLabel1.text = ""
        ibLabel2.text = ""
        ibLabel3.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configere(with data: MusicData) {
        ibLabel1.text = data.artistName
        ibLabel2.text = data.collectionName
        ibLabel3.text = data.trackName
        
        ibImageView.load(urlString: data.imageURL)
    }
    
}
