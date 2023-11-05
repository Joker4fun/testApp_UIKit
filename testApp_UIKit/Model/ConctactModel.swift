//
//  ConctactModel.swift
//  testApp_UIKit
//
//  Created by Антон Казеннов on 03.11.2023.
//

import Foundation
import UIKit

struct ContactsModel: Hashable {
    var firstName: String = ""
    var secondName: String = ""
    var phoneNumber: String = ""
    var image: UIImage?
    var isSelected: Bool = false

}


