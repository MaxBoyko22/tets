//
//  ImageModel.swift
//  ImageTest
//
//  Created by Maximilian Boiko on 04.03.2021.
//

import Foundation
import RealmSwift

struct ImageListModel: Decodable{
    var meta: Meta?
    var data: [ImageData]?
    var pagination: Pagination?
}

struct Meta: Decodable {
    var status: Int64?
    var msg: String?
    var response_id: String?
}

struct ImageData: Decodable {
    var title: String?
    var url: String?
    var images: images?
}

struct images: Decodable {
    var fixed_width_small: Downsized?
}

struct Downsized: Decodable {
    var url: String?
}

struct Pagination: Decodable {
    var totalCount: Int64?
    var count: Int64?
    var offset: Int64?
}



class ImageRealm: Object {
    @objc dynamic var id : String = " "
    @objc dynamic var searchName: String = " "
    @objc dynamic var title: String = " "
    @objc dynamic var url: String = " "
    @objc dynamic var gifData: Data? = nil
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
