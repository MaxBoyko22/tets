//
//  ImageCell.swift
//  ImageTest
//
//  Created by Maximilian Boiko on 03.03.2021.
//

import UIKit

class ImageCell: UITableViewCell {
    

    var img: UIImageView = {
        var view = UIImageView()
       return view
    }()
    
    private lazy var title: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 3
        return lbl
    }()
    
    private lazy var searchTitle: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(self.img)
        addSubview(self.title)
        addSubview(self.searchTitle)
        addConstaint()
        
    }
    
    func setUp(with model:ImageRealm){

        self.searchTitle.text = model.searchName
        self.title.text = model.title
    }
    
    private func addConstaint(){
        img.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90, height: 0, enableInsets: false)
        searchTitle.anchor(top: topAnchor, left: img.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
        title.anchor(top: searchTitle.bottomAnchor, left: img.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width / 2, height: 0, enableInsets: false)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
