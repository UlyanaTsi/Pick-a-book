//
//  GenreController.swift
//  Pick'a'book
//
//  Created by Ульяна Цимбалистая on 03.04.2022.
//

import UIKit
import PinLayout

private let reuseIdentifier = "Cell"

class SearchController: UICollectionViewController {
    let presenter: SearchPresenter!
    let genres = Util.shared.genres
    
    var searchController: UISearchController!
    var results:[Book] = []
    
    init(output: SearchPresenter){
        self.presenter = output
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Search Bar
        searchController = UISearchController()
        searchController.searchBar.placeholder = "Поиск по названию, автору"
        searchController.searchBar.tintColor = UIColor(named: "buttonColor")
        
        // NavBar
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Каталог"
        navigationItem.searchController = searchController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // View
        setCollectionView()
        
        // Presenter
        setPresenter()
    }
    
    func setCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let size = CGSize(width:(collectionView!.bounds.width - 30) / 2, height: 90)
        layout.itemSize = size
        
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GenreCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        self.view.addSubview(collectionView)
    }
    
    func setPresenter(){
        presenter.setViewDelegate(delegate: self)
    }
    
    func presentNextVC(genre: Genre){
        let presenterB = BooksCollectionPresenter()
        let vc = BooksCollectionController(output: presenterB, genre: genre)
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.navigationController?.navigationBar.tintColor = .black
        vc.modalPresentationStyle = .fullScreen
        vc.title = "\(genre.name)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
}

extension SearchController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count - 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GenreCell
        
        cell.configure(genre: genres[indexPath.row + 1])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genre = genres[indexPath.row + 1]
        presenter.chosedGenre(genre: genre)
    }
}

extension SearchController: UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else{return}
        
    }
    
}


