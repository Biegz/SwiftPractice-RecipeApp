//
//  Model.swift
//  RecipeApp
//
//  Created by Austin Biegler on 11/11/21.
//

import Foundation

//  This class helps with distiguishing sections within the table view delgate and data functions.
class MasterList {
    var cat: String?
    var meals: [Meal]
    
    init(cat: String, meals: [Meal]) {
        self.cat = cat
        self.meals = meals
    }
}

class Meal: Codable {
    var strMeal: String?
    var strMealThumb: String?
    var idMeal: String?
    
    init(strMeal: String, strMealThumb: String, idMeal: String){
        self.strMeal = strMeal
        self.strMealThumb = strMealThumb
        self.idMeal = idMeal
    }
}





//class Category: Codable {
//    let idCategory: String?
//    let strCategory: String?
//    let strCategoryThumb: String?
//    let strCategoryDescription: String?
//
//    init(idCategory: String, strCategory: String, strCategoryThumb: String, strCategoryDescription: String){
//        self.idCategory = idCategory
//        self.strCategory = strCategory
//        self.strCategoryThumb = strCategoryThumb
//        self.strCategoryDescription = strCategoryDescription
//    }
//}

struct Category: Codable {
    let idCategory: String?
    let strCategory: String?
    let strCategoryThumb: String?
    let strCategoryDescription: String?
}




//class RecipeCategory: Codable {
//    let categories: [Category]?
//
//    init(categories: [Category]){
//        self.categories = categories
//    }
//}

struct RecipeCategory: Codable {
    let categories: [Category]?
}






class RecipeMeal: Codable {
    let meals: [Meal]?
    
    init(meals: [Meal]) {
        self.meals = meals
    }
}


//  This class helps with distiguishing sections within the table view delgate and data functions.
class CombinedValues {
    var type: String?
    var list: [String]
    
    init(type: String?, list: [String]) {
        self.type = type
        self.list = list
    }
    
}

struct Result: Codable {
    let meals: [ResultItem]
}

struct ResultItem: Codable {
    var strInstructions: String?
    
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
    var strIngredient16: String?
    var strIngredient17: String?
    var strIngredient18: String?
    var strIngredient19: String?
    var strIngredient20: String?
    var strMeasure1: String?
    var strMeasure2: String?
    var strMeasure3: String?
    var strMeasure4: String?
    var strMeasure5: String?
    var strMeasure6: String?
    var strMeasure7: String?
    var strMeasure8: String?
    var strMeasure9: String?
    var strMeasure10: String?
    var strMeasure11: String?
    var strMeasure12: String?
    var strMeasure13: String?
    var strMeasure14: String?
    var strMeasure15: String?
    var strMeasure16: String?
    var strMeasure17: String?
    var strMeasure18: String?
    var strMeasure19: String?
    var strMeasure20: String?
    
    //  ALLOWS TO LATER ITERATE THROUGH THE INGREDIENTS/MEASURES
    func toDic() -> [String:Any] {
        var dict = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                dict[key] = child.value
            }
        }
        return dict
    }
    
}
