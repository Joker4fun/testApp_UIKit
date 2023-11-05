//
//  BonussViewCell.swift
//  testApp_UIKit
//
//  Created by Антон Казеннов on 04.11.2023.
//

import UIKit

class BonussViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var cintactImage: UIImageView!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func prepareForReuse() {
        cintactImage.image = nil
    }
    //метод для наполнения ячейки
    func config(_ presenter: ContactsModel?) {
        guard let presenter = presenter else { return }
        self.nameLabel.text = presenter.firstName + " " + presenter.secondName
        self.phoneNumber.text = presenter.phoneNumber
        self.cintactImage.image = presenter.image
    }
}




