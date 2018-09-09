//
//  SearchResponse.swift
//  MoneyTapTest
//
//  Created by Divum on 09/09/18.
//  Copyright © 2018 Murali. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchResponse: Mappable {
    var batchcomplete: Bool?
    var query: Query?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        batchcomplete <- map["batchcomplete"]
        query <- map["query"]
    }
}

class Query: Mappable {
    var pages: [Page]?
    var redirects: [Redirect]?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        pages <- map["pages"]
        redirects <- map["redirects"]
    }
}

class Page: Mappable {
    var index: Int?
    var ns: Int?
    var pageid: Int?
    var terms: Term?
    var title: String?
    var thumbnail: Thumbnail?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        index <- map["index"]
        ns <- map["ns"]
        pageid <- map["pageid"]
        terms <- map["terms"]
        title <- map["title"]
        thumbnail <- map["thumbnail"]
    }
}

class Redirect: Mappable {
    var from: String?
    var index: Int?
    var to: String?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        from <- map["from"]
        index <- map["index"]
        to <- map["to"]
    }
}

class Thumbnail: Mappable {
    var height: Int?
    var source: String?
    var width: Int?
    
    required init?(map: Map){}
    
    func mapping(map: Map) {
        height <- map["height"]
        source <- map["source"]
        width <- map["width"]
    }
}


class Term: Mappable {
    var description: [String]?
  
    required init?(map: Map){}
    
    func mapping(map: Map) {
        description <- map["description"]
    }
}
