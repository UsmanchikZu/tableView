//
//  ViewController.swift
//  table
//
//  Created by aeroclub on 11.11.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var tableView: UITableView = {
        var table = UITableView(frame: view.bounds, style: .insetGrouped)
        
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
    }()
    
    private lazy var shuffleButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("shuffle", for: .normal)
        button.addTarget(self, action: #selector(shuffleData), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.frame = CGRect(x: view.frame.width - 120, y: 40, width: 120, height: 40)
        
        return button
    }()
    
    private var items: [Int] = Array(1...30)
    private var checkedItems: Set<Int> = []
    var isShuffling = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(tableView)
        view.addSubview(shuffleButton)
    }
    
    @objc func shuffleData() {
        if !isShuffling {
            isShuffling = true
            shuffleButton.isEnabled = false
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveEaseInOut, .transitionCrossDissolve], animations: {
                self.items.shuffle()
                self.tableView.reloadData()
            }) { _ in
                self.isShuffling = false
                self.shuffleButton.isEnabled = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "Item \(items[indexPath.row])"
        cell.accessoryType = checkedItems.contains(items[indexPath.row]) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        
        if checkedItems.contains(selectedItem) {
            
            checkedItems.remove(selectedItem)
            
            let originalIndex = items.firstIndex(of: selectedItem)
            
            if let originalRow = originalIndex, originalRow != indexPath.row {
                
                items.remove(at: indexPath.row)
                items.insert(selectedItem, at: originalRow)
                
                tableView.moveRow(at: indexPath, to: IndexPath(row: originalRow, section: 0))
            }
        } else {
            
            checkedItems.insert(selectedItem)
            
            items.remove(at: indexPath.row)
            items.insert(selectedItem, at: 0)
            
            
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        }
        
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        if indexPath.row != 0 {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
