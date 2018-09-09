//
//  ApiManager.swift
//  MoneyTapTest
//
//  Created by Divum on 09/09/18.
//  Copyright © 2018 Murali. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

public class SearchApiManager {
    
    func searhForText(searchText:String){
        let URL = Api.BASE_URL + Api.SEARCH_URL + searchText
        print(URL)
        Alamofire.request(URL).responseObject { (response: DataResponse<SearchResponse>) in
            let searchResponse = response.result.value
//            print(searchResponse?.batchcomplete)
        }
    }
}
