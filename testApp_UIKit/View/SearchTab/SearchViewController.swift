//
//  SearchViewController.swift
//  testApp_UIKit
//
//  Created by Антон Казеннов on 02.11.2023.
//

import UIKit
import Contacts
import Combine

class SearchViewController: UIViewController {
    
    var presenter: SearchPresenterProtocol!
    private var store: Set<AnyCancellable> = []
    
    
    let searchBar: UITextField = {
        let textBar = UITextField()
        textBar.borderStyle = .roundedRect
        textBar.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .medium)
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: largeConfig)
        imageView.image = image
        textBar.leftView = imageView
        return textBar
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(searchBar)
        stack.addArrangedSubview(tableView)
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setBindings()
        presenter.makeContactExample("")
        setupConstraints()
    }
    
    //метод для скрытия клавиатуры
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    func setBindings() {
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //добавляем обработчик нажатий, для нажатий вне поля поиска
        let tap = UITapGestureRecognizer(target: self, action:
                                            #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //слушаем строку поиска
        searchBar.textPublisher
            .receive(on: RunLoop.main)
            .dropFirst(2)
            .assign(to: \.searchText , on: presenter)
            .store(in: &store)
    }
}

// MARK: - Extensions

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.allContacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        let contact = presenter.allContacts?[indexPath.row]
        cell.config(contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: cell.contentView.frame.height)
        //добавляем анимации как в примере
        UIView.animate(withDuration: 0.5, delay : 0.01 * Double(indexPath.row),animations: {
            cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
        })
    }
}

extension SearchViewController: SearchViewProtocol {
    func success() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            print("TableView reloaded")
        }
    }
    
    func failure() {
        print("Error")
    }
}

extension SearchViewController {
    // задаем констрейнты
    private func setupConstraints () {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint (equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint (equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0 ).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leftAnchor.constraint (equalTo: stackView.leftAnchor, constant: 0).isActive = true
        searchBar.rightAnchor.constraint (equalTo: stackView.rightAnchor, constant: 0).isActive = true
        
    }
}
