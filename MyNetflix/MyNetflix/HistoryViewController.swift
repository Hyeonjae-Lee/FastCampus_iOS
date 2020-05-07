//
//  HistoryViewController.swift
//  MyNetflix
//
//  Created by apple on 2020/05/07.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var searchTerms: [SearchTerm] = []
    
    let db = Database.database().reference().child("searchHistory")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db.observeSingleEvent(of: .value) { (snapshot) in
            
            // parsing
            guard let searchHistory = snapshot.value as? [String: Any] else { return }
            let datas = Array(searchHistory.values)
            
            let data = try! JSONSerialization.data(withJSONObject: datas, options: [])
            
            let decoder = JSONDecoder()
            let searchTerm = try! decoder.decode([SearchTerm].self, from: data)
            self.searchTerms = searchTerm.sorted(by: { (term1, term2) -> Bool in
                return term1.timestamp < term2.timestamp
            })
            self.tableView.reloadData()
            
            print("\(datas)")
        }
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }
        
        cell.searchTerm.text = searchTerms[indexPath.row].term
        
        return cell
    }
    
    
}



class HistoryCell: UITableViewCell {
    @IBOutlet weak var searchTerm: UILabel!
    
}

struct SearchTerm: Codable {
    let term: String
    let timestamp: TimeInterval
}
