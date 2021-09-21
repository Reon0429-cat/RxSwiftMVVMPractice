//
//  Beer.swift
//  RxSwiftMVVMPractice
//
//  Created by 大西玲音 on 2021/09/22.
//

import Foundation
import RealmSwift

struct Beer: Codable, Equatable {
    var id: Int?
    var name: String?
    var description: String?
    var imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "image_url"
    }
}
 
class BeerRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var desc = ""
    @objc dynamic var imageURL = ""
    
    convenience init(beer: Beer) {
        self.init()
        self.id = beer.id!
        self.name = beer.name!
        self.desc = beer.description!
        self.imageURL = beer.imageURL ?? ""
    }
}

extension BeerRealm {
    
    func toDTO() -> Beer {
        return Beer(id: id, name: name, description: desc, imageURL: imageURL)
    }
    
}
