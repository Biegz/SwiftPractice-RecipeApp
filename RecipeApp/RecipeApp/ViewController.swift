//
//  ViewController.swift
//  RecipeApp
//
//  Note: Either classes or structs can be used. I show an example of the use of structs in 'MealDetailViewController'. These classes can also be moved to another file. 
//
//  Created by Austin Biegler on 11/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories = [Category]()
    var masterList = [MasterList]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        async {
            let obj = await fetchCategories()
            if let catArray = obj.categories {
                for cat in catArray {
                    if cat.strCategory != "" {
                        self.categories.append(cat)
                    }
                }
            }
            if self.categories.count > 0 {
                fetchMealData()
            }
        }
    }
    
    
    private func fetchCategories() async -> RecipeCategory {
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let obj = try JSONDecoder().decode(RecipeCategory.self, from: data)
            return obj
        } catch {
            return RecipeCategory(categories: [])
        }
    }
    
    
    ///  Fetches meals by category. Any meal that is missing data is not added to tableView data. Categories and meals are sorted alphabetically. Reloads tableView data upon completion on main thread.
    ///
    ///  No parameters
    ///  No return value
    func fetchMealData(){
        for tmpCategory in self.categories {
            let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=" + tmpCategory.strCategory!)!
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    return
                }
                do {
                    let obj = try JSONDecoder().decode(RecipeMeal.self, from: data)
                    
                    //  REMOVE OCCURENCES OF NULL ATTRIBUTES
                    var tmpMeals: [Meal] = []
                    for meal in obj.meals! {
                        if meal.strMeal != nil && meal.idMeal != nil && meal.strMealThumb != nil {
                            let tmpMeal = Meal(strMeal: meal.strMeal!, strMealThumb: meal.strMealThumb!, idMeal: meal.idMeal!)
                            tmpMeals.append(tmpMeal)
                        }
                    }
                    
                    
                    let tmpList = MasterList(cat: tmpCategory.strCategory!, meals: tmpMeals)
                    self.masterList.append(tmpList)
                    
                    DispatchQueue.main.async {
                        //  SORT CATEGORY
                        self.masterList.sort(by: {$0.cat! < $1.cat!})
                        //  SORT MEALS
                        for cat in self.masterList {
                            cat.meals.sort(by: {$0.strMeal! < $1.strMeal!})
                        }
                        self.tableView.reloadData()
                    }
                }
                catch {
                    let error = error
                    print("error")
                }
            }.resume()
        }
    }
    


}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.masterList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.masterList[section].meals.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mealTitle = masterList[indexPath.section].meals[indexPath.row].strMeal
        let mealID = masterList[indexPath.section].meals[indexPath.row].idMeal
        
        //  GO TO MEAL DETAIL VIEW CONTROLLER
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MealDetailViewController_ID") as! MealDetailViewController
        vc.title = mealTitle
        vc.mealID = mealID!
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealCell
        let mealTitle = masterList[indexPath.section].meals[indexPath.row].strMeal
        cell.mainLabel.text = mealTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        20
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return masterList[section].cat
    }
}



