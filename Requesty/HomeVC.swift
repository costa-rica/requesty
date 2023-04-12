//
//  ViewController.swift
//  Requesty
//
//  Created by Nick Rodriguez on 12/04/2023.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet var lblFirst: UILabel!
    
    @IBAction func changeResponseValue(_ sender: Any) {
        let sender = sender as! UISegmentedControl
        if sender.selectedSegmentIndex == 0 {
            self.lblFirst.text = requestyDict["item1"]
        } else {
            self.lblFirst.text = requestyDict["item2"]
        }
    }
    
    var requestyDict = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.processResponse()
    }

    // craete url
    func makeUrl() -> URL{
        let baseURLString = "http://127.0.0.1:5001/json01"
        
        let components = URLComponents(string:baseURLString)!
        return components.url!
    }
    
    // create session
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // create dataTask and send request
    func fetchJson01(completion: @escaping([String:String]) -> Void){
        let url = makeUrl()
        let request = URLRequest(url:url)
        let task = session.dataTask(with: request) { (data,response,error) in
            guard let unwrapped_data = data else {
                print("Data is nil")
                return
            }
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: unwrapped_data, options: []) as! [String:String]
                OperationQueue.main.addOperation {
                    completion(jsonDict)
                }
                
            } catch {
                print("Error converting to json")
            }
        }
        task.resume()
    }
    
    // create function to receive response
    func processResponse() {
        fetchJson01 { responseDict in
            self.lblFirst.text = responseDict["item1"]
            self.requestyDict = responseDict
        }
    }
    
    
}

