//
//  ModelMoex.swift
//  SharesMoex
//
//  Created by macbook on 02.04.2021.
//

import Foundation
import Unrealm

//Дженерик, т.к. возникла идея сделать не только акции, но и облигации
//но со свободным временем получилась беда...
struct Root<T: Decodable> : Decodable {
    //TODO доделать логику для курсора
    private enum CodingKeys : String, CodingKey {
        case response = "history"
        //case responseCursor = "history.cursor"
    }
    
    let response : response<T>
    //let responseCursor: [String]
}

struct response<T: Decodable> : Decodable {
    private enum CodingKeys : String, CodingKey {
        case items = "data"
    }
    
    let items : [T]
}

struct Shares: Decodable, Identifiable, Realmable {
    
    static func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys : String, CodingKey {
        case boardID = "BOARDID"
        case id = "SECID"
        case tradeDate = "TRADEDATE"
        case shortName = "SHORTNAME"
        case value = "VALUE"
        case open = "OPEN"
        case close = "CLOSE"
    }
    
    var boardID: String = ""
    var id: String?
    var tradeDate: Date?
    var shortName: String?
    var value: Int?
    var open: Double?
    var close: Double?
}
