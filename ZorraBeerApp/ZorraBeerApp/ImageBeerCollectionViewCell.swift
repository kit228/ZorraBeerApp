//
//  ImageBeerCollectionViewCell.swift
//  ZorraBeerApp
//
//  Created by Вениамин Китченко on 17.07.2021.
//

import UIKit

class ImageBeerCollectionViewCell: UICollectionViewCell { // ячейка в beerCollectionVIew
    static let beerCellId = "beerCellId"
    
    let imageViewBeerCell: UIImageView = { // создаем imageView для картинки с пивом
        let imageView = UIImageView()
//        if #available(iOS 13.0, *) {
//            imageView.image = UIImage(systemName: "house")
//        } else {
//            // Fallback on earlier versions
//        }
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let beerNameLabel: UILabel = { // создаем лейбл для названия пива
        let label = UILabel()
        //label.text = "Пиво"
        label.backgroundColor = .clear
        //label.backgroundColor = .black
        //label.textColor = .white
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //contentView.backgroundColor = .darkGray // цвет внутри ячейки
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .secondarySystemBackground // цвет внутри ячейки
        } else {
            contentView.backgroundColor = .white // цвет внутри ячейки
        }
        contentView.addSubview(imageViewBeerCell)
        contentView.addSubview(beerNameLabel)
        contentView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // -- вариант с текстом снизу
        imageViewBeerCell.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height - 50)
        beerNameLabel.frame = CGRect(x: 0, y: contentView.frame.size.height - 50, width: contentView.frame.size.width, height: 50)
        
        // -- вариант с текстом сверху
//        imageViewBeerCell.frame = CGRect(x: 0, y: 50, width: contentView.frame.size.width, height: contentView.frame.size.height - 50)
//        beerNameLabel.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: 50)
    }
    
    
    public func configureBeerName(beerName: String) { // вызвав эту функцию - меняем и текст ячейки
        beerNameLabel.text = beerName
    }
    
    public func configureBeerImage(image: UIImage?) { // вызвав эту функцию - меняем изображение
        imageViewBeerCell.image = image
    }
    
    override func prepareForReuse() { // подготоваливаем ячейку для переиспользования
        super.prepareForReuse()
        imageViewBeerCell.image = nil
        beerNameLabel.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
