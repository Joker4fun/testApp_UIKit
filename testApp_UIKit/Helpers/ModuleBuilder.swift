//
//  ModuleBuilder.swift
//  testApp_UIKit
//
//  Created by Антон Казеннов on 02.11.2023.
//

import UIKit

protocol Builder {
  static func createMain () -> UIViewController
  static func createBonusView() -> UIViewController
}

class ModelBuilder: Builder{
   
    // создание главного экрана
  static func createMain() -> UIViewController {
      let view = SearchViewController()
      let contactService = Contacts()
      let presenter = SearchViewPresenter(view: view, contactService: contactService)
      view.presenter = presenter
      return view
  }
    
    // создание бонусного экрана
    static func createBonusView() -> UIViewController {
        let view = BonusViewController()
        let contactService = Contacts()
        let presenter = BonusViewPresenter(view: view, contactService: contactService)
        view.presenter = presenter
        return view

    }

}
