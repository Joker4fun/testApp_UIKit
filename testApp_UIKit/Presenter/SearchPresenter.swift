//
//  MainPresenter.swift
//  TestApp_KazennovAI
//
//  Created by Антон Казеннов on 02.11.2023.
//

import Foundation
import Contacts
import Combine
import UIKit

protocol SearchViewProtocol: AnyObject {
    func success()
    func failure()
}

protocol SearchPresenterProtocol: AnyObject {
    init(view: SearchViewProtocol, contactService: ContactsProtocol)
    var allContacts: [ContactsModel]? { get set }
    var searchText: String { get set }
    func makeContactExample(_ str: String)}

class SearchViewPresenter: SearchPresenterProtocol {
    
    @Published var searchText: String = ""
    var allContacts: [ContactsModel]? = []
    var view: SearchViewProtocol!
    let contactService: ContactsProtocol!
    private var store: Set<AnyCancellable> = []
    required init(view: SearchViewProtocol, contactService: ContactsProtocol) {
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



// MARK: - for Combine search in UITextField
// Подписываемся на NotificationCenter
extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextField)?.text  ?? "" }
            .eraseToAnyPublisher()
    }
}
