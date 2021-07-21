//
//  BeerInfoViewController.swift
//  ZorraBeerApp
//
//  Created by Вениамин Китченко on 20.07.2021.
//

import UIKit

class BeerInfoViewController: UIViewController { // второй viewController с детальной информацией о пиве
    
    var scrollView = UIScrollView() // объявляем scrollView
    //var scrollView: UIScrollView! // объявляем scrollView
    let beerImageView = UIImageView() // объявляем imageView для изображения пива
    
    
    var beer: Beer? // пиво
    
    
    let beerInfoLabel: UILabel = { // лейбл с информацией о пиве
        let label = UILabel()
        //label.text = "текст лейбла"
        label.numberOfLines = 0 // чтобы текст переносился на следующую строку
        label.sizeToFit()
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            label.textColor = .black
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        setupScrollView() // добавляем scrollView
        setupImageView() // добавляем imageView
        setupBeerInfoLabel() // добавляем textView
        
        setupGestureRecognizer() // добавляем обработчик тапа
        
    }
    
    
    
    func setupScrollView() { // настройка scrollView
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView) // добавляем во вью scrollView
        if #available(iOS 13.0, *) {
            scrollView.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
            scrollView.backgroundColor = .white
        }
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    
    func setupImageView() { // настройка imageView
        
        if beerImageView.image != nil { // если картинка есть, то добавляем imageView
            beerImageView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(beerImageView)
            
            beerImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            beerImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            beerImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 60).isActive = true
            
            //beerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
            beerImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/5).isActive = true
            
            beerImageView.contentMode = .scaleAspectFit
        }

        
    }
    
    
    func setupBeerInfoLabel() { // настройка лэйбла beerInfo
        scrollView.addSubview(beerInfoLabel)
        
        if beerImageView.image != nil { // если картинка есть, ставим такую позицию
            beerInfoLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            beerInfoLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 3/4).isActive = true
            beerInfoLabel.topAnchor.constraint(equalTo: beerImageView.bottomAnchor, constant: 40).isActive = true
            beerInfoLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        } else { // иначе, такую
            beerInfoLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            beerInfoLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 3/4).isActive = true
            beerInfoLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 80).isActive = true
            beerInfoLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        }
        
        if let beer = beer { // записоваем текст
            beerInfoLabel.text = beer.name + "\n" + "\n" + beer.description + "\n" + "\n" + beer.ingredients + "\n" + "\n" + beer.foodPairing
        }
        
    }
    
    
    
    func setupGestureRecognizer() { // настройка обработчика тапа, чтобы по нажатию вернуться на предыдущий экран
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        scrollView.isUserInteractionEnabled = true
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    
    @objc func goBack() { // действие, вызываемое по тапу singleTapGestureRecognizer
    //@objc func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil) // возвращение на предыдущий экран
    }
    
}
