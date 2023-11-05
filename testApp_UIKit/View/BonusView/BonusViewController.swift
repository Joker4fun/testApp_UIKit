//
//  ViewController.swift
//  testApp_UIKit
//
//  Created by Антон Казеннов on 02.11.2023.
//


import UIKit
import Contacts
import Combine

class BonusViewController: UIViewController {
    
    var presenter: BonusPresenterProtocol!
    private var store: Set<AnyCancellable> = []
    private var mostViewedContacts:Set<ContactsModel> = []
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentSize = CGSize(width: view.frame.width + 400, height: 70)
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame.size = CGSize(width: view.frame.width + 400, height: 70)
        return contentView
    }()
    
    private let stackImageView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var searchBar: UITextField = {
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
    
    private lazy var tableView: UITableView = {
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
        overrideUserInterfaceStyle = .light   //светлая тема приятнее
        setBindings()
        presenter.makeContactExample("")
        setupViewsConstraints()
    }
    
    func setBindings() {
        view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.register(UINib.init(nibName: "BonusTableViewCell", bundle: nil), forCellReuseIdentifier: "CellBonus")
        
        //слушаем строку поиска
        searchBar.textPublisher
            .receive(on: RunLoop.main)
            .dropFirst(2)
            .assign(to: \.searchText , on: presenter)
            .store(in: &store)
    }
}

// MARK: - Extensions

extension BonusViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.allContacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellBonus", for: indexPath) as! BonussViewCell
        let contact = presenter.allContacts?[indexPath.row]
        cell.config(contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: cell.contentView.frame.height)
        UIView.animate(withDuration: 0.5, delay : 0.01 * Double(indexPath.row),animations: {
            cell.transform = CGAffineTransform(translationX: cell.contentView.frame.width, y: cell.contentView.frame.height)
        })
    }
}

extension BonusViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? BonussViewCell else {
            return
        }
        // изменяем иконку кнопки при нажатии на ячейку
        cell.checkBox.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        
        //добавляем экземпляры в Set для уникальности и что бы не было повторний при повторных нажатиях по ячейке
        mostViewedContacts.insert(ContactsModel(firstName: cell.nameLabel.text!, secondName: "", phoneNumber: cell.phoneNumber.text!, image: cell.cintactImage.image, isSelected: true))
        
        //удаляем все View с верхнего ScrollView из stackImageView
        stackImageView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        //проходимся по Set и добавляем все экземпляры в ScrollView
        for images in mostViewedContacts {
            let new = UIImageView()
            new.image = images.image
            new.clipsToBounds = true
            new.layer.cornerRadius = 25
            stackImageView.addArrangedSubview(new)
        }
        
        //задаем размеры
        for view in stackImageView.arrangedSubviews {
            view.widthAnchor.constraint(equalToConstant: 60).isActive = true
            view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
    }
}

extension BonusViewController: BonusViewProtocol {
    //обновляем таблицу
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

extension BonusViewController {
    private func setupViewsConstraints () {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint (equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint (equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0 ).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        contentView.addSubview(stackImageView)
        stackImageView.translatesAutoresizingMaskIntoConstraints = false
        stackImageView.leftAnchor.constraint (equalTo: contentView.leftAnchor, constant: 0).isActive = true
        stackImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        stackImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        for view in stackImageView.arrangedSubviews {
            view.widthAnchor.constraint(equalToConstant: 50).isActive = true
            view.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
        }
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint (equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint (equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0 ).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.leftAnchor.constraint (equalTo: stackView.leftAnchor, constant: 0).isActive = true
        searchBar.rightAnchor.constraint (equalTo: stackView.rightAnchor, constant: 0).isActive = true
    }
}
