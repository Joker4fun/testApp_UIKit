//
//  BonusPresenter.swift
//  testApp_UIKit
//
//  Created by Антон Казеннов on 04.11.2023.
//

import Foundation
import Contacts
import Combine
import UIKit

protocol BonusViewProtocol: AnyObject {
    func success()
    func failure()
}

protocol BonusPresenterProtocol: AnyObject {
    init(view: BonusViewProtocol, contactService: ContactsProtocol)
    var allContacts: [ContactsModel]? { get set }
    var mostViewContacts: [ContactsModel] {get set}
    var searchText: String { get set }
    func makeContactExample(_ str: String)}

class BonusViewPresenter: BonusPresenterProtocol {
    
    
    @Published var searchText: String = ""
    var allContacts: [ContactsModel]? = []
    var mostViewContacts: [ContactsModel] = []
    var view: BonusViewProtocol!
    let contactService: ContactsProtocol!
    private var store: Set<AnyCancellable> = []
    required init(view: BonusViewProtocol, contactService: ContactsProtocol) {
        self.view = view
        self.contactService = contactService
        
        //Ставим слушателя на TextField
        $searchText
            .dropFirst(1)
            .sink {self.makeContactExample($0)}
            .store(in: &store)
    }
    
    // добавление данных в модель по строке поиска с фильтрацией
    func makeContactExample(_ str: String) {
        if !str.isEmpty {
            contactService.makeRequest(searchText) { data in
                guard let data = data else { return }
                self.allContacts = data.filter{$0.firstName.lowercased().contains(self.searchText.lowercased()) || $0.secondName.lowercased().contains(self.searchText.lowercased()) || $0.phoneNumber.contains(self.searchText) }
                self.view.success()
                print(self.allContacts?.count as Any)
                self.view.success()
            }
        }else {
            // если строка поиска пустая, то выгрузить все контакты
            contactService.makeRequest(searchText) { data in
                guard let data = data else { return }
                self.allContacts = data
                self.view.success()
            }
        }
    }
}

