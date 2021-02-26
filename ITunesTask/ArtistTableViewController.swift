//
//  ArtistTableViewController.swift
//  ITunesTask
//
//  Created by Lenovo on 26/02/21.
//

import UIKit

class ArtistTableViewController: UITableViewController, UISearchResultsUpdating {
    var urlRequest:URLRequest!
    var dataTaskObj:URLSessionDataTask!
    var artistSearchBar:UISearchController!
    var serializedObj:Any?
    @IBOutlet var artistSV: UIScrollView!
    @IBOutlet var artistTV: UITableView!
    @IBOutlet var artistLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        connectToServer()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    //creating an function to connect to server
    func connectToServer(){
        //creating an instance of artist search bar
        artistSearchBar = UISearchController(searchResultsController: nil)
        artistTV.tableHeaderView = artistSearchBar.searchBar
        artistSearchBar.searchResultsUpdater = self
    }
    func updateSearchResults(for searchController: UISearchController) {
        //creating an instance of urlRequest and connecting to server through url request
        print(searchController.searchBar.text!)
        if artistSearchBar.isActive == true{
        //urlRequest = URLRequest(url: URL(string: "https://services.brninfotech.com/tws/MovieDetails2.php?mediaType=\(searchController.searchBar.text!)")!)
            urlRequest = URLRequest(url: URL(string: "https://itunes.apple.com/search?term=\(searchController.searchBar.text!)".replacingOccurrences(of: " ", with: ""))!)
            
        //passing url request method
        urlRequest.httpMethod = "GET"
        //creating an instance of url session data task
        dataTaskObj = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error == nil{
                //exception handling
                do{
                    //creating an instance of JSON Serializ ation
                    var serializedObj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(serializedObj)
                    self.serializedObj = serializedObj
                    DispatchQueue.main.async {
                        self.artistLabel.text = "\(serializedObj)".replacingOccurrences(of: "}", with: "").replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                        self.artistLabel.sizeToFit()
                        self.artistSV.contentSize = CGSize(width: self.view.frame.width, height: self.artistLabel.frame.maxY)
                        
                        self.artistTV.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
                        
                        self.artistTV.reloadData()
                    }
                    
                }catch{
                    //creating label to display if error occurs
                    var errorLabel = UILabel()
                    errorLabel.frame = CGRect(x: 30, y: 200, width: 360, height: 400)
                    errorLabel.text = "\(error.localizedDescription)"
                    self.view.addSubview(errorLabel)
                }
            }
        })
        dataTaskObj.resume()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "\(serializedObj!)"
        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
