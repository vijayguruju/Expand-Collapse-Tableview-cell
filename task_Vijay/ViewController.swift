//
//  ViewController.swift
//  task_Vijay
//
//  Created by Dinesh Sunder on 30/08/19.
//  Copyright © 2019 vijay. All rights reserved.
//

import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}
//
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    
    var tableViewData = [cellData]()
    @IBOutlet weak var tableView: UITableView!
    var allMenuResponse:AllMenuResponse?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        getData()
    }

    //Get data from Json file
    func getData(){
        
        if let path = Bundle.main.path(forResource: "AllMenu", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [[String:Any]]
                
                var names = [String]()
                var subCategories = [[String:Any]]()
                var subCatName = [[[String:Any]]]()
                for name in jsonResult{
                    names.append(name["name"] as! String)
                }
                for subCategory in jsonResult{
                    subCategories.append(subCategory)
                    if let subCat = subCategory["sub_category"] as? [[String:Any]] {
                    subCatName.append(subCat)
                    }
                }
                self.allMenuResponse = AllMenuResponse(name: names, subCategory: subCatName, dataArray: jsonResult)
                
                print("names",self.allMenuResponse?.name?.count ?? "")
                print("Sub cat",self.allMenuResponse?.subCategory?.count ?? "")
               // var subData = [[String:Any]]()
                if let data = self.allMenuResponse{
                    
                        for i in 0..<data.name!.count{
                            var subNameAndCats = [String]()

                            for subs in data.subCategory![i]{
                            let subName = subs["name"] as! String
                            let disName = subs["display_name"] as! String
                            subNameAndCats.append(subName)
                            subNameAndCats.append(disName)
                            
                            }
                            print(subNameAndCats.count)
                            let celldata = cellData(opened: false, title: data.name![i], sectionData: subNameAndCats )
                            tableViewData.append(celldata)
                        }
                    }
                    print(tableViewData)

                    tableView.reloadData()
               
            } catch {
                //  error
                print("Error")
            }
        }
    }
    
    //MARK:- Table View methods
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true{
            return tableViewData[section].sectionData.count + 1
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1
        if indexPath.row == 0 {
            let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = tableViewData[indexPath.section].title
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubCell", for: indexPath)
            //cell.textLabel?.text = tableViewData[indexPath.section].sectionData[dataIndex["name"]]
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[dataIndex]
            cell.separatorInset.left = 40
            cell.textLabel?.numberOfLines = 0
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if tableViewData[indexPath.section].opened == true{
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
        else {
            let dataIndex = indexPath.row - 1
            let filterName = tableViewData[indexPath.section].title
            let filterValue = tableViewData[indexPath.section].sectionData[dataIndex]
            
            print("\(filterName)" + ":" + "\(filterValue)")
           
            
        }
    }
    
}

