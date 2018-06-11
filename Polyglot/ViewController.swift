//
//  ViewController.swift
//  Polyglot
//
//  Created by Amanda Reinhard on 5/26/18.
//  Copyright © 2018 Amanda Reinhard. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var words = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleAttributes = [NSAttributedStringKey.font: UIFont(name: "AmericanTypewriter", size: 22)!]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        title = "POLYGLOT"
        
        if let defaults = UserDefaults(suiteName: "group.com.amreinhard.Polyglot") {
            if let savedWords = defaults.object(forKey: "Words") as? [String] {
                words = savedWords
            } else {
                saveInitialValues(to: defaults)
            }
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewWord))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        
        let word = words[indexPath.row]
        let split = word.components(separatedBy: "::")
        
        cell.textLabel?.text = split[0]
        
        cell.detailTextLabel?.text = ""
        
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView!.backgroundColor = UIColor(white: 1, alpha: 0.20)
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func saveInitialValues(to defaults: UserDefaults) {
        words.append("bear::l'ours")
        words.append("camel::le chameau")
        words.append("cow::la vache")
        words.append("fox::le renard")
        words.append("goat::la chèvre")
        words.append("monkey::le singe")
        words.append("pig::le cochon")
        words.append("rabbit::le lapin")
        words.append("sheep::le mouton")
        
        defaults.set(words, forKey: "Words")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        words.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveWords()
    }
    
    func saveWords() {
        if let defaults = UserDefaults(suiteName: "group.com.amreinhard.Polyglot") {
        defaults.set(words, forKey: "Words")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.detailTextLabel?.text == "" {
                let word = words[indexPath.row]
                let split = word.components(separatedBy: "::")
                cell.detailTextLabel?.text = split[1]
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
    }
    
    func insertFlashcard(first: String, second: String) {
        guard first.count > 0 && second.count > 0 else { return }
        let newIndexPath = IndexPath(row: words.count, section: 0)
        
        words.append("\(first)::\(second)")
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        saveWords()
    }
    
    @objc func addNewWord() {
        let ac = UIAlertController(title: "Add new word", message: nil, preferredStyle: .alert)
        
        ac.addTextField { textField in
            textField.placeholder = "English"
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "French"
        }
        
        let submitAction = UIAlertAction(title: "Add Word", style: .default) { [unowned self, ac] (action: UIAlertAction!) in
            let firstWord = ac.textFields?[0].text ?? ""
            let secondWord = ac.textFields?[1].text ?? ""
            
            self.insertFlashcard(first: firstWord, second: secondWord)
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
}

