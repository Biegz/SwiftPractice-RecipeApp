//
//  MealDetailViewController.swift
//  RecipeApp
//
//  Note: A scroll view can be utilized for the instructions. It is possible to add one and autolayout it above the tableView however time did not permit.
//
//  Created by Austin Biegler on 11/10/21.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    var mealID = ""
    var combinedValues: [CombinedValues] = []
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fetchMealInfo()
    }
    

    ///  Fetches meal information based on the current meals' ID
    ///
    ///  No parameters
    ///  No return value
    func fetchMealInfo(){
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=" + self.mealID)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            do {
                let obj = try JSONDecoder().decode(Result.self, from: data)
                
                DispatchQueue.main.async {

                    for tmpObj in obj.meals {
                        self.instructionLabel.text = tmpObj.strInstructions

                        var ingredients: [String:String] = [:]
                        var measures: [String:String] = [:]
                        
                        //  GET DICTIONARY OF STRUCT OBJECT
                        var tmpDic = tmpObj.toDic()
                        tmpDic.removeValue(forKey: "strInstructions")
                        for (key,value) in tmpDic {

                            //  GET NUMBER VALUE AT TAIL OF KEY
                            let num = key
                                .components(separatedBy:CharacterSet.decimalDigits.inverted)
                                .joined()

                            //  ADD TO RESPECTIVE DICTIONARY
                            if key.starts(with: "strMeasure") {
                                if let tmpStr = value as? String {
                                    if tmpStr != "" && tmpStr != " " {
                                        measures[num] = tmpStr
                                    }
                                }
                            } else {
                                if let tmpStr = value as? String {
                                    if tmpStr != "" && tmpStr != " " {
                                        ingredients[num] = tmpStr
                                    }
                                }
                            }
                        }
                        
                        //  COMBINE DICTIONARIES BASED ON KEY
                        var tmpList: [String] = []
                        for (key,value) in measures {
                            tmpList.append(measures[key]! + " " + ingredients[key]!)
                        }
                        let tmpMaster = CombinedValues(type: "Ingredients", list: tmpList)
                        self.combinedValues.append(tmpMaster)
                    }
                    self.tableView.reloadData()
                }
            }
            catch {
                let error = error
                print("error: \(error)")
            }
        }
        task.resume()
    }


}

extension MealDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    //  NUMBER OF
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.combinedValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.combinedValues[section].list.count
    }
    
    
    
    
    
    
    //  CELL
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OtherCell", for: indexPath) as! OtherCell
        let tmpTitle = combinedValues[indexPath.section].list[indexPath.row]
        cell.mainLabel.text = tmpTitle
        return cell
    }
    
    
    
    
    
    //  HEADER
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return combinedValues[section].type
    }
    

    
}
