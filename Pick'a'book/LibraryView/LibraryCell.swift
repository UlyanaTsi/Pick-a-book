//
//  LibraryCell.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 11.04.2022.
//

import Foundation
import UIKit
import PinLayout

class BookTableCell: UITableViewCell {
    
    let bookImage = UIImageView()
    let bookNameLabel = UILabel()
    let bookAuthorLabel = UILabel()
    
    func configure(with book: Book) {
        // Картинка книги
        bookImage.contentMode = UIView.ContentMode.scaleAspectFill
        // Если картинки нет или она не грузится, то ставим картинку по умолчанию
        if (book.bookImages.count == 0){
            bookImage.image = UIImage(named: "default")
        } else {
            bookImage.image = UIImage(data: book.bookImages[0])
        }
        
        bookNameLabel.text = book.bookName
        bookAuthorLabel.text = book.bookAuthor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        
        bookImage.backgroundColor = UIColor.purple
        bookImage.layer.cornerRadius = 20
        bookImage.layer.masksToBounds = true
        contentView.addSubview(bookImage)
        
        bookNameLabel.font = bookNameLabel.font.withSize(16)
        contentView.addSubview(bookNameLabel)
        
        bookAuthorLabel.font = bookAuthorLabel.font.withSize(14)
        contentView.addSubview(bookAuthorLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bookImage.pin
            .top(10)
            .left(10)
            .size(80)
        
        bookNameLabel.pin
            .top(26)
            .right(of: bookImage, aligned: .top).marginLeft(10)
            .height(20)
            .right(10)
        
        bookAuthorLabel.pin
            .below(of: bookNameLabel).marginTop(8)
            .right(of: bookImage, aligned: .top).marginLeft(10)
            .height(20)
            .right(10)
    }
}
