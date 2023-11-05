//
//  BonusTableViewCell.swift
//  testApp_UIKit
//
//  Created by Антон Казеннов on 04.11.2023.
//


import UIKit

class BonusTableViewCell: UITableViewCell {
    
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var cintactImage: UIImageView!
    @IBOutlet weak var checkBox: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "CellBonus")
       // setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        cintactImage.image = nil
    }
    
    func config(_ presenter: ContactsModel?) {
        guard let presenter = presenter else { return }
        self.nameLabel.text = presenter.firstName + " " + presenter.secondName
        self.phoneNumber.text = presenter.phoneNumber
        self.cintactImage.image = presenter.image
        
    }
}

