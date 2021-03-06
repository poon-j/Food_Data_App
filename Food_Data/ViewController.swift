//
//  ViewController.swift
//  Food_Data
//
//  Created by Jonathan Poon on 3/5/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate,
                      UITableViewDataSource {

    @IBOutlet weak var field: UITextField!
    
    @IBOutlet weak var table: UITableView!
    
    var foods = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        field.delegate = self
        
    
    }
    
    
    //Field
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchFoods()
        return true
    }
    
    func searchFoods() {
        field.resignFirstResponder()
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        let query = text.replacingOccurrences(of: " ", with: "%20")
        
        
        foods.removeAll()
        
        let url = "https://api.nal.usda.gov/fdc/v1/foods/search?api_key=ydI7ncStcPABndEjDCKR2WkpulLVx2w0HlDngH9R&query=\(query)&dataType=Survey%20(FNDDS)&pageSize=5"
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            //have data
            var result:Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch {
                print("failed to convert \(error.localizedDescription)")
            }
            
            guard let finalResult = result else {
                return
            }
            
            //Update foods array
            
            for n in 0...finalResult.foodSearchCriteria.pageSize - 1 {
                let food = Food(name: finalResult.foods[n].description,
                                calories: finalResult.foods[n].foodNutrients[3].value,
                                protein: finalResult.foods[n].foodNutrients[0].value,
                                carbs: finalResult.foods[n].foodNutrients[2].value,
                                fat: finalResult.foods[n].foodNutrients[1].value)
                
                self.foods.append(food)
                print(self.foods[n].name)
            }
            
            
            //Refresh table
            DispatchQueue.main.async {
                self.table.reloadData()
            }
            
            
        }).resume()
        
        
    }
    
    
    //Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.configure(with: foods[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func getData(from url: String) {
       
    }
    
    struct Response : Codable {
        let totalHits: Int
        let foodSearchCriteria: FoodSearchCriteria_JSON
        let foods: [Foods_JSON]
    }
    
    struct FoodSearchCriteria_JSON : Codable {
        let query: String
        let pageSize:Int
    }
    
    struct Foods_JSON : Codable {
        let description: String
        let foodNutrients: [Nutrient_JSON]
    }
    
    struct Nutrient_JSON : Codable {
        let nutrientId: Int
        let nutrientName: String
        let nutrientNumber: String
        let unitName: String
        let value: Double
    }

    
}

struct Food {
    let name: String
    let calories: Double
    let protein: Double
    let carbs: Double
    let fat: Double
    
}
/*
 
 {"totalHits":658,
 "currentPage":1,
 "totalPages":658,
 "pageList":[1,2,3,4,5,6,7,8,9,10],
 "foodSearchCriteria":{
    "dataType":["Survey (FNDDS)"],
    "query":"cheddar cheese",
    "generalSearchInput":"cheddar cheese",
    "pageNumber":1,
    "numberOfResultsPerPage":50,
    "pageSize":1,
    "requireAllWords":false,
    "foodTypes":["Survey (FNDDS)"]},
"foods":[{
    "fdcId":1098007,
    "description":"Cheese, Cheddar",
    "lowercaseDescription":"cheese, cheddar",
    "commonNames":"",
    "additionalDescriptions":"Longhorn;Tillamook;Coon;Hoop;Pioneer;sharp cheese;Wisconsin;New York",
    "dataType":"Survey (FNDDS)",
    "foodCode":"14104100",
    "publishedDate":"2020-10-30",
    "allHighlightFields":"<b>Includes</b>: Longhorn;Tillamook;Coon;Hoop;Pioneer;sharp <em>cheese</em>;Wisconsin;New York",
    "score":462.7636,
    "foodNutrients":[
        {"nutrientId":1003,"nutrientName":"Protein","nutrientNumber":"203","unitName":"G","value":23.3},
        {"nutrientId":1004,"nutrientName":"Total lipid (fat)","nutrientNumber":"204","unitName":"G","value":34.0},
        {"nutrientId":1005,"nutrientName":"Carbohydrate, by difference","nutrientNumber":"205","unitName":"G","value":2.44},
        {"nutrientId":1008,"nutrientName":"Energy","nutrientNumber":"208","unitName":"KCAL","value":408},
        {"nutrientId":1018,"nutrientName":"Alcohol, ethyl","nutrientNumber":"221","unitName":"G","value":0.0},
        {"nutrientId":1051,"nutrientName":"Water","nutrientNumber":"255","unitName":"G","value":36.6},
        {"nutrientId":1057,"nutrientName":"Caffeine","nutrientNumber":"262","unitName":"MG","value":0.0},
        {"nutrientId":1058,"nutrientName":"Theobromine","nutrientNumber":"263","unitName":"MG","value":0.0},
        {"nutrientId":2000,"nutrientName":"Sugars, total including NLEA","nutrientNumber":"269","unitName":"G","value":0.33},
        {"nutrientId":1079,"nutrientName":"Fiber, total dietary","nutrientNumber":"291","unitName":"G","value":0.0},
        {"nutrientId":1087,"nutrientName":"Calcium, Ca","nutrientNumber":"301","unitName":"MG","value":707},
        {"nutrientId":1089,"nutrientName":"Iron, Fe","nutrientNumber":"303","unitName":"MG","value":0.16},
        {"nutrientId":1090,"nutrientName":"Magnesium, Mg","nutrientNumber":"304","unitName":"MG","value":27.0},
        {"nutrientId":1091,"nutrientName":"Phosphorus, P","nutrientNumber":"305","unitName":"MG","value":458},
        {"nutrientId":1092,"nutrientName":"Potassium, K","nutrientNumber":"306","unitName":"MG","value":77.0},
        {"nutrientId":1093,"nutrientName":"Sodium, Na","nutrientNumber":"307","unitName":"MG","value":654},
        {"nutrientId":1095,"nutrientName":"Zinc, Zn","nutrientNumber":"309","unitName":"MG","value":3.67},
        {"nutrientId":1098,"nutrientName":"Copper, Cu","nutrientNumber":"312","unitName":"MG","value":0.033},
        {"nutrientId":1103,"nutrientName":"Selenium, Se","nutrientNumber":"317","unitName":"UG","value":28.3},
        {"nutrientId":1105,"nutrientName":"Retinol","nutrientNumber":"319","unitName":"UG","value":316},
        {"nutrientId":1106,"nutrientName":"Vitamin A, RAE","nutrientNumber":"320","unitName":"UG","value":316},
        {"nutrientId":1107,"nutrientName":"Carotene, beta","nutrientNumber":"321","unitName":"UG","value":0.0},
        {"nutrientId":1108,"nutrientName":"Carotene, alpha","nutrientNumber":"322","unitName":"UG","value":0.0},{"nutrientId":1109,"nutrientName":"Vitamin E (alpha-tocopherol)","nutrientNumber":"323","unitName":"MG","value":0.75},{"nutrientId":1114,"nutrientName":"Vitamin D (D2 + D3)","nutrientNumber":"328","unitName":"UG","value":0.6},{"nutrientId":1120,"nutrientName":"Cryptoxanthin, beta","nutrientNumber":"334","unitName":"UG","value":0.0},{"nutrientId":1122,"nutrientName":"Lycopene","nutrientNumber":"337","unitName":"UG","value":0.0},{"nutrientId":1123,"nutrientName":"Lutein + zeaxanthin","nutrientNumber":"338","unitName":"UG","value":0.0},{"nutrientId":1162,"nutrientName":"Vitamin C, total ascorbic acid","nutrientNumber":"401","unitName":"MG","value":0.0},{"nutrientId":1165,"nutrientName":"Thiamin","nutrientNumber":"404","unitName":"MG","value":0.029},{"nutrientId":1166,"nutrientName":"Riboflavin","nutrientNumber":"405","unitName":"MG","value":0.441},{"nutrientId":1167,"nutrientName":"Niacin","nutrientNumber":"406","unitName":"MG","value":0.052},{"nutrientId":1175,"nutrientName":"Vitamin B-6","nutrientNumber":"415","unitName":"MG","value":0.069},{"nutrientId":1177,"nutrientName":"Folate, total","nutrientNumber":"417","unitName":"UG","value":21.0},{"nutrientId":1178,"nutrientName":"Vitamin B-12","nutrientNumber":"418","unitName":"UG","value":1.06},{"nutrientId":1180,"nutrientName":"Choline, total","nutrientNumber":"421","unitName":"MG","value":16.5},{"nutrientId":1185,"nutrientName":"Vitamin K (phylloquinone)","nutrientNumber":"430","unitName":"UG","value":2.4},{"nutrientId":1186,"nutrientName":"Folic acid","nutrientNumber":"431","unitName":"UG","value":0.0},{"nutrientId":1187,"nutrientName":"Folate, food","nutrientNumber":"432","unitName":"UG","value":21.0},{"nutrientId":1190,"nutrientName":"Folate, DFE","nutrientNumber":"435","unitName":"UG","value":21.0},{"nutrientId":1242,"nutrientName":"Vitamin E, added","nutrientNumber":"573","unitName":"MG","value":0.0},{"nutrientId":1246,"nutrientName":"Vitamin B-12, added","nutrientNumber":"578","unitName":"UG","value":0.0},{"nutrientId":1253,"nutrientName":"Cholesterol","nutrientNumber":"601","unitName":"MG","value":100},{"nutrientId":1258,"nutrientName":"Fatty acids, total saturated","nutrientNumber":"606","unitName":"G","value":19.2},{"nutrientId":1259,"nutrientName":"4:0","nutrientNumber":"607","unitName":"G","value":0.653},{"nutrientId":1260,"nutrientName":"6:0","nutrientNumber":"608","unitName":"G","value":0.543},{"nutrientId":1261,"nutrientName":"8:0","nutrientNumber":"609","unitName":"G","value":0.349},{"nutrientId":1262,"nutrientName":"10:0","nutrientNumber":"610","unitName":"G","value":0.843},{"nutrientId":1263,"nutrientName":"12:0","nutrientNumber":"611","unitName":"G","value":0.963},{"nutrientId":1264,"nutrientName":"14:0","nutrientNumber":"612","unitName":"G","value":3.1},{"nutrientId":1265,"nutrientName":"16:0","nutrientNumber":"613","unitName":"G","value":8.79},{"nutrientId":1266,"nutrientName":"18:0","nutrientNumber":"614","unitName":"G","value":3.39},{"nutrientId":1268,"nutrientName":"18:1","nutrientNumber":"617","unitName":"G","value":7.41},{"nutrientId":1269,"nutrientName":"18:2","nutrientNumber":"618","unitName":"G","value":1.16},{"nutrientId":1270,"nutrientName":"18:3","nutrientNumber":"619","unitName":"G","value":0.121},{"nutrientId":1271,"nutrientName":"20:4","nutrientNumber":"620","unitName":"G","value":0.051},{"nutrientId":1272,"nutrientName":"22:6 n-3 (DHA)","nutrientNumber":"621","unitName":"G","value":0.001},{"nutrientId":1275,"nutrientName":"16:1","nutrientNumber":"626","unitName":"G","value":0.516},{"nutrientId":1276,"nutrientName":"18:4","nutrientNumber":"627","unitName":"G","value":0.001},{"nutrientId":1277,"nutrientName":"20:1","nutrientNumber":"628","unitName":"G","value":0.064},{"nutrientId":1278,"nutrientName":"20:5 n-3 (EPA)","nutrientNumber":"629","unitName":"G","value":0.01},{"nutrientId":1279,"nutrientName":"22:1","nutrientNumber":"630","unitName":"G","value":0.001},{"nutrientId":1280,"nutrientName":"22:5 n-3 (DPA)","nutrientNumber":"631","unitName":"G","value":0.018},{"nutrientId":1292,"nutrientName":"Fatty acids, total monounsaturated","nutrientNumber":"645","unitName":"G","value":7.44},{"nutrientId":1293,"nutrientName":"Fatty acids, total polyunsaturated","nutrientNumber":"646","unitName":"G","value":1.18}]
    }],
 "aggregations":{"dataType":{"Branded":41772,"Survey (FNDDS)":658,"SR Legacy":282,"Foundation":9},"nutrients":{}}
 
 }
    
 */
