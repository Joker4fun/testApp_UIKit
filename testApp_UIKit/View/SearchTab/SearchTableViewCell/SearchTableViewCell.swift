//
//  SearchTableViewCell.swift
//  TestApp_KazennovAI
//
//  Created by Антон Казеннов on 02.11.2023.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    lazy var imageC: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = image.frame.size.width/2
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var contactName: UILabel = {
        let text = UILabel()
        text.font = .systemFont(ofSize: 20)
        return text
    }()
    
    private lazy var phoneNumber: UILabel = {
        let text = UILabel()
        text.numberOfLines = .zero
        text.font = .systemFont(ofSize: 15)
        return text
    }()

    private lazy var stackV: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(contactName)
        stack.addArrangedSubview(phoneNumber)
        stack.spacing = 5
        return stack
    }()
    private lazy var stackH: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.addArrangedSubview(imageC)
        stack.spacing = 10
        stack.addArrangedSubview(stackV)
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "Cell")
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        imageC.image = nil
    }
    //метод для наполнения ячейки
    func config(_ presenter: ContactsModel?) {
        guard let presenter = presenter else { return }
        contactName.text = presenter.firstName + " " + (presenter.secondName )
        phoneNumber.text = presenter.phoneNumber
        self.imageC.image = presenter.image
    }
    
    private func setupConstraints () {
        contentView.addSubview(stackH)
        stackH.translatesAutoresizingMaskIntoConstraints = false
        stackH.leftAnchor.constraint (equalTo: contentView.leftAnchor, constant: 0).isActive = true
        stackH.rightAnchor.constraint (equalTo: contentView.rightAnchor, constant: 0 ).isActive = true
        stackH.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        stackH.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        imageC.translatesAutoresizingMaskIntoConstraints = false
        imageC.leftAnchor.constraint (equalTo: stackH.leftAnchor, constant: 0).isActive = true
        imageC.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageC.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

