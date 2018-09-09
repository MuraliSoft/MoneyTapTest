//
//  HomeVC.swift
//  MoneyTapTest
//
//  Created by Divum on 09/09/18.
//  Copyright © 2018 Murali. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire
import SDWebImage

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchResponse: SearchResponse?
    var recentSearchItems: [SearchItem]?
    var selectedSearchTest: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = UIColor.white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = ["All", "Recent"]
        searchController.searchBar.delegate = self
      
        //Setup Searchbar Appearance
        UISearchBar.appearance().barTintColor = UIColor.white
        UISearchBar.appearance().tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        
     
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getRecentSearches()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - PARSER -
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if(scope == "All"){
            let escapedString = searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            let URL = Api.BASE_URL + Api.SEARCH_URL + escapedString!
            print(URL)
            Alamofire.request(URL).responseObject { (response: DataResponse<SearchResponse>) in
                self.searchResponse = response.result.value
                self.tableView.reloadData()
            }
        }else{
            self.searchResponse = nil
            self.tableView.reloadData()
        }
       
    }
    func getRecentSearches() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        self.recentSearchItems = appDelegate.getRecentSearches()
        self.tableView.reloadData()
    }
    
    // MARK: - Table View Data Source & Delegates
    
    // number of rows in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if(section == 0){
            if let searchRes = self.searchResponse {
                if let query = searchRes.query {
                    return (query.pages?.count)!
                }
            }
        }else if(section == 1){
            if(self.recentSearchItems != nil){
                return (self.recentSearchItems?.count)!
            }
        }
        
        return 0
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Search Results"
//        }else if(section == 1 && (self.recentSearchItems == nil || self.recentSearchItems?.count == 0) && self.searchResponse == nil){
//            return "Pull down the list and start search";
//        }
//        return "Recenty Searched";
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 30)) //set these values as necessary
        returnedView.backgroundColor = UIColor.orange
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.view.frame.size.width - 20, height: 30))
        var headerTitle = ""
        if section == 0 {
            headerTitle =  "Search Results"
        }else if(section == 1 && (self.recentSearchItems == nil || self.recentSearchItems?.count == 0) && self.searchResponse == nil){
            headerTitle =  "Pull down the list and start search";
        }else{
            headerTitle =  "Recenty Searched";
        }
        label.text = headerTitle
        label.textColor = UIColor.white
        
        returnedView.addSubview(label)
        
        return returnedView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && self.searchResponse == nil {
            return 0
        }else if section == 1 && self.recentSearchItems == nil {
            return 0
        }
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell",
                                                 for: indexPath) as! SearchResultCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none;
  
        if(indexPath.section == 0){
             //Show the item from Search Results
            let result = self.searchResponse?.query?.pages![indexPath.row];
            let termsArray = result?.terms?.description;
            let decription = termsArray?.joined(separator: ", ")
            print(termsArray)
            
            let imageURL = result?.thumbnail?.source
            
            cell.titleLabel.text = result?.title
            cell.descriptionLabel.text = decription
            
            if imageURL != nil{
                cell.contentImageView.sd_setImage(with: URL.init(string: imageURL!) , placeholderImage: nil)
            }else{
                cell.contentImageView.image = nil
            }
        }else if(indexPath.section == 1){
            //Show the item from Local Storage
            let result = self.recentSearchItems![indexPath.row];
            cell.titleLabel.text = result.title
            cell.descriptionLabel.text = result.desc
            
            if let imageURL:String = result.thumbnail as String{
                cell.contentImageView.sd_setImage(with: URL.init(string:imageURL) , placeholderImage: nil)
            }else{
                cell.contentImageView.image = nil
            }
        }
    
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            // Get the selected result from search results
            let result = self.searchResponse?.query?.pages![indexPath.row];
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let termsArray = result?.terms?.description;
            let decription = termsArray?.joined(separator: ", ")
            
            //Save the selected items into local storage - in core data
            let item = SearchItem()
            item.itemId = (result?.pageid)!
            item.title = (result?.title)!
            if decription != nil{
                item.desc = decription!
            }
            if result?.thumbnail?.source != nil {
                item.thumbnail = (result?.thumbnail?.source)!
            }
            appDelegate.addSearchItem(item: item)
            
            //Assign the selected item in a global variable - From Search Result
            self.selectedSearchTest = result?.title
            
        }else if(indexPath.section == 1){
            let result = self.recentSearchItems![indexPath.row];
            
            //Assign the selected item in a global variable - From Local Storage
            self.selectedSearchTest = result.title
        }
        
        
        performSegue(withIdentifier: "details", sender: nil)
    }
   
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "details" {
            let detailsViewController: DetailsVC = segue.destination as! DetailsVC
            detailsViewController.searchText = self.selectedSearchTest
        }
    }
    

}

extension HomeVC: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
}

extension HomeVC: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
}
