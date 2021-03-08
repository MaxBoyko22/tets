//
//  ViewController.swift
//  ImageTest
//
//  Created by Maximilian Boiko on 03.03.2021.
//

import UIKit
import RealmSwift
import Kingfisher

protocol ShowAlert: class {
    func show()
}


class MainViewController: UIViewController {
    let cellId = "cellId"
    var images : [ImageData] = []
    var model = [ImageRealm]()
    let realm = try! Realm()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.backgroundColor = .white
        field.layer.cornerRadius = 5
        field.layer.borderWidth = 0.3
        field.layer.borderColor = UIColor.gray.cgColor
        field.returnKeyType = .search
        field.delegate = self
        return field
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getImag()
        tableView.delegate = self
        tableView.dataSource = self
        
        let apiService = QueriesToAPI.shared
        apiService.delegate = self
        
        tableView.register(ImageCell.self, forCellReuseIdentifier: cellId)
        setUpConstraints()
    }
    
    private func setUpConstraints(){
        addTextField()
        addTableView()
    }
    
    func getImages(search:String){
        
        QueriesToAPI.shared.getImage(query: search, completion:{ (data,error) in
            DispatchQueue.main.async {
                if let unwrapedData = data {
                    self.images = self.images + unwrapedData
                    
                    self.addToRealm(imgs: self.images.last! , search: search )
                    
                } else {
                    print("nil")
                }
            }
        })
    }
    
    func addToRealm(imgs: ImageData,search: String){
        let image = ImageRealm()
        do{
            try! realm.write {(
                image.id = UUID().uuidString,
                image.title = imgs.title!,
                image.url = (imgs.images?.fixed_width_small?.url)!,
                image.searchName = search,
                realm.add(image),
                try realm.commitWrite(),
                model.append(image)
            )}
            tableView.reloadData()
        }
    }
    
    func getImag(){
        let object = realm.objects(ImageRealm.self)
        model = .init(object)
    }
    
    private func addTextField(){
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    
    private func addTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: textField.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if model.count != 0{
            return   model.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ImageCell
        let image = model[indexPath.row]
        cell.setUp(with: image)
        
        
        GetGifs.shared.loadGifFromURl(imageObject: image, completion: {(data,error) in
            if error == nil{
                    cell.img.image = UIImage.init(data: data!)
            }
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MainViewController: UITextFieldDelegate { 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil{
            let trimmed = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            getImages(search: trimmed)
            
            textField.resignFirstResponder()
        }else{
            print("lol")
        }
        return true
    }
    
}

extension MainViewController: ShowAlert {
    func show() {
        
        let alert = UIAlertController(title: "Error", message: "gif not found", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
    
    
}



