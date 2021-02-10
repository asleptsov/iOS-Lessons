//
//  MainViewController.swift
//  Lessons
//
//  Created by Anton Sleptsov on 09.02.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    private let serviceUrl = "https://api.github.com/users/asleptsov/repos"
    
    private var records: [GithubRecord] = []
    
    private var tableView: UITableView!
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .systemBlue
        self.view = view
        
        setupTableView()
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        
        view.addSubview(tableView)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.tableView = tableView
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }
    
    private func fetchData() {
        guard let url = URL(string: serviceUrl) else {
            return
        }
        
        let dataTask = URLSession(configuration: .default).dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            if let records = try? decoder.decode([GithubRecord].self, from: data) {
                DispatchQueue.main.async {
                    self?.records = records
                    self?.tableView.reloadData()
                }
            }
        }
        
        dataTask.resume()
    }
}

// MARK: -UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId")!
        cell.textLabel?.text = records[indexPath.row].name
        return cell
    }
    
}
