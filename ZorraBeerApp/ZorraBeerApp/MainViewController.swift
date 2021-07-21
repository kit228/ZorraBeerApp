//
//  ViewController.swift
//  ZorraBeerApp
//
//  Created by Вениамин Китченко on 16.07.2021.
//


import UIKit

//class MainViewController: UIViewController, UICollectionViewDelegate {
class MainViewController: UIViewController {
    
    var beerArray: [Beer] = [] // массив с пивом
    
    var beerCollectionView: UICollectionView? // объявляем collectionView
    var beerRefreshControl: UIRefreshControl! // объявляем refresh control
    
    //var pageNumber: Int = Int.random(in: 1...40) // номер запрашиваемой страницы
    var pageNumber: Int = 100 // номер запрашиваемой страницы
    var itemsPerPage: Int = 10 // количество запрашиваемых элементов на странице
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        
        
        let width = view.frame.width - 1 // записываем размер ячейки по ширине экрана - делаем одну картинку на строку и оставляем один пиксель (-1) для отступа
        layout.itemSize = CGSize(width: width, height: width) // указываем размер ячеек по ширине экрана
        layout.minimumInteritemSpacing = 1 // расстояние между ячеек
        layout.minimumLineSpacing = 50 // расстояние между ячейками снизу
        layout.scrollDirection = .vertical
        beerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        
        guard let beerColectionView = beerCollectionView else {return} // разворачиваем beerColectionView
        
        beerColectionView.register(ImageBeerCollectionViewCell.self, forCellWithReuseIdentifier: ImageBeerCollectionViewCell.beerCellId) // регистрируем ячейку
        
        
        if #available(iOS 13.0, *) { // устанавливаем фон collectionView
            beerColectionView.backgroundColor = .secondarySystemBackground // чтобы отображался корректно, в соответствии с темой ОС
        } else {
            // Fallback on earlier versions
            beerColectionView.backgroundColor = UIColor.white
        }
        
        
        beerColectionView.dataSource = self
        beerColectionView.delegate = self // для UICollectionViewDelegateFlowLayout
 
        view.addSubview(beerColectionView)
        beerColectionView.frame = view.bounds
        
        
        // добавляем refreshControl
        beerRefreshControl = UIRefreshControl()
        beerRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged) // действие, которое нужно выполнить при запуске refreshControl
        beerColectionView.addSubview(beerRefreshControl)
        
        requestBeerJson() { // запрашиваем пиво
            completion: do {
                print("Выполнен запрос пива")
            }
        }
    }
    
    
    @objc func refresh(_ sender: Any) { // действие, при запуске refreshControl
        print("Запустили refresh control")
        beerArray = [] // очистили массив с пивом
        
        pageNumber = Int.random(in: 1...40) //меняем номер запрашиваемой страницы
        requestBeerJson() { // запрашиваем пиво
            completion: do {
                beerRefreshControl.endRefreshing()
                print("end Refreshing")
            }
        }
        
    }
    
    
    func getRequestStringForBeer() -> String { // делаем запрашиваемую строку
        let dumbString = "https://api.punkapi.com/v2/beers?"
        let page = "page=" + String(pageNumber)
        let perPage = "&per_page=" + String(itemsPerPage)
        return dumbString + page + perPage
    }
    
    
    func requestBeerJson(completion: () -> Void) { // запрос пива
        guard let url = URL(string: getRequestStringForBeer()) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in // делаем url-запрос
            guard let responsedData = data else {
                print("Не был получен ответ на url-запрос, ошибка: \(error)")
                return
            }
            // парсим json-ответ
            do {
                let parsedResponse = try JSONDecoder().decode(Array<BeerJsonResponseStruct>.self, from: responsedData)
                print("json-ответ распарсен успешно!")
                //print(parsedResponse[0])
                print("parsedResponse.count = ", parsedResponse.count)
                if parsedResponse.count == 0 { // если в ответе ноль результатов - запрашиваем повторно
                    
                    
                    /* -- примечание кода ниже:
                     
                     Хотел сделать небольшую задержку в асинхронной очереди, чтобы при нулевых результатах не задедосило сервер (при отключенном интернете само себя зацикливать не будет, потому что вопросы вообще не будут выполняться). Однако, сделал неправильно, потому что иногда при записи названия пива в ячейку происходит вылет - Fatal error: Index out of range. Видимо, что-то где-то выполняется раньше, чем нужно. Искать причину нет времени.
                    */
                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { // задержка
//                        self.pageNumber = Int.random(in: 1...40) //меняем номер запрашиваемой страницы
//                        self.requestBeerJson {
//                            completion: do {
//                                print("Запросили повторно")
//                            }
//                        }
//                    }
                    
                    
                    self.pageNumber = Int.random(in: 1...40) //меняем номер запрашиваемой страницы
                    self.requestBeerJson {
                        completion: do {
                            print("Запросили повторно")
                        }
                    }
                }
                
//                for element in parsedResponse { // заполняем массив с пивом
//                    let beer = Beer(name: element.name, description: element.description, imageUrl: element.imageUrl, ingredients: String(element.ingredients.hops[0].name), foodPairing: element.food_pairing[0])
//                    self.beerArray.append(beer) // добавляем в массив пиво
//                }
                
                for element in parsedResponse { // заполняем массив с пивом
                    let beer = Beer(name: element.name, description: element.description, imageUrl: element.imageUrl, ingredients: self.prepareIngredientsToString(ingredients: element.ingredients), foodPairing: self.prepareFoodPairingToString(foodPairing: element.food_pairing))
                    self.beerArray.append(beer) // добавляем в массив пиво
                }
                
                DispatchQueue.main.async { // в основной очереди перезагружаем collectionView
                    self.beerCollectionView?.reloadData()
                }
            }
            catch let parsingResponseError {
                print("Ошибка парсинга json-ответа: \(parsingResponseError)")
            }
        }
        .resume() // для URLDataTask
        completion() // помечаем, что функция выполнена
    }
    
    
    func prepareIngredientsToString(ingredients: IngredientsStruct) -> String { // делаем из ингредиентов строку
        var stringToReturn = ""
        if !ingredients.malt.isEmpty { // если солод ингредиентах есть, то:
            stringToReturn += "Malt:"
            for element in ingredients.malt {
                stringToReturn += "\n" + element.name + " " + String(element.amount.value) + " " + element.amount.unit
            }
            stringToReturn += "\n" + "\n"
        }
        
        if !ingredients.hops.isEmpty { // если хмель в ингредиентах есть, то:
            stringToReturn += "Hops:"
            for element in ingredients.hops {
                stringToReturn += "\n" + element.name + " " + String(element.amount.value) + " " + element.amount.unit + " " + element.add + " " + element.attribute
            }
        }
        
        return stringToReturn
    }
    
    
    func prepareFoodPairingToString(foodPairing: [String]) -> String { // делаем из сочетаемой еды строку
        var stringToReturn = ""
        
        if !foodPairing.isEmpty {
            stringToReturn += "Food pairing:" + "\n"
            var cycleCount = 0 // счетчик циклов, чтобы в конце запятую не ставить
            for element in foodPairing {
                cycleCount += 1
                stringToReturn += element
                if cycleCount != foodPairing.endIndex {
                    stringToReturn += ", "
                }
            }
        }
        
        return stringToReturn
    }
    
}



extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout { // работа с CollectionView, UICollectionViewDelegateFlowLayout - для настройки отображения
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beerArray.count // сколько вернуть ячеек
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let beerCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageBeerCollectionViewCell.beerCellId, for: indexPath) as! ImageBeerCollectionViewCell // объявляем ячейку
        
        
        beerCell.configureBeerName(beerName: beerArray[indexPath.row].name) // записываем название пива в ячейке
        getImage(beer: beerArray[indexPath.row], cell: beerCell) // получаем картинку в ячейку
        
        return beerCell
    }
    
    func getImage(beer: Beer, cell: ImageBeerCollectionViewCell) { // получить картинку по строковому url из кеша или загрузить
        var gettedImage: UIImage?
        if let stringImageUrl = beer.imageUrl {
            if let url = URL(string: stringImageUrl) {
                print("Запрашиваем картинку из кеша или грузим, beer.imageUrl = \(beer.imageUrl)")
                ImageDownloader.imageDownloaderSingletone.downloadImageOrCache(imageUrl: url) { image in
                    gettedImage = image
                    
                    DispatchQueue.main.async { // в основной очереди меняем картинку ячейки
                        cell.configureBeerImage(image: gettedImage)
                    }
                    
                }
            }
        } else { // если нет URL - ставим заглушку
            print("URL пустой, ставим заглушку, beer.imageUrl = \(beer.imageUrl)")
            gettedImage = UIImage(named: "noBeerPicture")
        }
        DispatchQueue.main.async { // в основной очереди меняем картинку ячейки
            cell.configureBeerImage(image: gettedImage)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // действие по нажатию на ячейку
        print("Нажата ячейка indexPath.row = \(indexPath.row) в секции indexPath.section = \(indexPath.section)")
        
        let beerInfoViewController = BeerInfoViewController() // создаем экземляр второго viewController'а
        
        let choosedBeer = beerArray[indexPath.row] // выбранное пиво
        
        if let stringImageUrl = choosedBeer.imageUrl {
            if let url = URL(string: stringImageUrl) {
                ImageDownloader.imageDownloaderSingletone.downloadImageOrCache(imageUrl: url) { image in
                    beerInfoViewController.beerImageView.image = image
                }
            }
        }
        
        beerInfoViewController.beer = choosedBeer // записываем пиво в beerInfoViewController
        
        // параметры отображения и переход
        beerInfoViewController.modalPresentationStyle = .fullScreen // отображение вью контроллера
        beerInfoViewController.modalTransitionStyle = .coverVertical // анимация перехода
        present(beerInfoViewController, animated: true) // переходим на второй viewController
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItemNumber = beerArray.count - 1
        if indexPath.row == lastItemNumber {
            print("Последняя ячейка")
            pageNumber += 1 // прибавляем запрашиваемую страницу
            requestBeerJson {
                
            }
        }
    }
    
    
    
}
