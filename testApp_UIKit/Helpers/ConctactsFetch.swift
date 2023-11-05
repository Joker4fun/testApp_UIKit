//
//  ConctactsFetch.swift
//  testApp_UIKit
//
//  Created by Антон Казеннов on 03.11.2023.
//

import Foundation
import Contacts
import UIKit

protocol ContactsProtocol: AnyObject {
    func makeRequest(_ searchString: String?, completion: @escaping([ContactsModel]?) -> Void)
    func makeContact(_ contact: CNContact) -> ContactsModel
}

class Contacts: ContactsProtocol {
    
    private let store = CNContactStore()
    private var emptyModel:[ContactsModel] = []
    
    
    func makeContact(_ contact: CNContact) -> ContactsModel {
        var newContact = ContactsModel()
        newContact.firstName = contact.givenName
        newContact.secondName = contact.familyName
        newContact.phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
        
        // проверка на доступность аватрки
        switch contact.imageDataAvailable {
        case true: newContact.image = UIImage(data: contact.imageData!)!
        case false: newContact.image = UIImage(systemName: "face.smiling.fill")!
        }
        return newContact
    }
    
    // метод для получения списка контактов в модель
    func makeRequest(_ searchString: String?, completion: @escaping([ContactsModel]?) -> Void){
        self.emptyModel = []
        DispatchQueue.global().async {
            //ключи для поиска по полям
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactImageDataAvailableKey, CNContactThumbnailImageDataKey]
            
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            
            request.sortOrder = CNContactSortOrder.givenName
            do {
                try self.store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                    self.emptyModel.append(self.makeContact(contact))
                })
            } catch let err {
                print("Failed to enumerate contacts:", err)
            }
            completion(self.emptyModel)
        }
    }
}


