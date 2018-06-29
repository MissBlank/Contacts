//
//  ViewController.swift
//  Contacts
//
//  Created by NERC on 2018/6/29.
//  Copyright © 2018年 GaoNing. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    let ScreenWidth = UIScreen.main.bounds.width
    let ScreenHeight = UIScreen.main.bounds.height
    
    var mainTableView = UITableView()
    var mainSearchBar : UISearchBar!
    var modelArr : Array<ContactModel>!
    
    /// 所有联系人信息的字典
    var addressBookSouce = [String:[ContactModel]]()
    /// 所有分组的key值
    var keysArray = [String]()
    
    var nameArray = [String]()
    
    var isSearch:Bool = false
    
    
    var result = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainTableView = UITableView.init(frame: CGRect(x: 0, y: 88, width: ScreenWidth, height: ScreenHeight-88))
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        self.view.addSubview(mainTableView)
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
        view.backgroundColor = UIColor.gray
        
        result = nameArray
        mainSearchBar = UISearchBar.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 50))
        mainSearchBar.delegate = self
        mainSearchBar.placeholder = "输入想找的联系人姓名"
        //        mainSearchBar.showsCancelButton = true             //有cancel按钮
        
        
        view.addSubview(mainSearchBar)
        mainTableView.tableHeaderView = view
        
        self.addModel()
        let result1 = ContactList.getOrderContacts(modelArray: modelArr)
        addressBookSouce = result1.contentDic
        keysArray = result1.nameKeys
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSearch {
            return 1
        }
        else{
            return keysArray.count
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return result.count
        }
        else{
            let key = keysArray[section]
            let array = addressBookSouce[key]
            return array!.count
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isSearch {
            return keysArray[section]
        }
        else{
            return nil
        }
        
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if !isSearch {
            return keysArray
        }else{
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        
        if isSearch {
            cell.textLabel?.text = result[indexPath.row]
        }
        else{
            let modelAry = addressBookSouce[keysArray[indexPath.section]]
            let model = modelAry![indexPath.row]
            
            cell.textLabel?.text = model.name
        }
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //UISearchBarDelegate
    override func touchesBegan(_ touches:Set<UITouch>, with event:UIEvent?) {
        
        mainSearchBar.resignFirstResponder()
        
    }
    
    //1. 选择的scope发生变化
    
    func searchBar(_ searchBar:UISearchBar, selectedScopeButtonIndexDidChange selectedScope:Int) {
        
        print(selectedScope)
        
    }
    
    //    2. 实时监测输入的文字
    
    func searchBar(_ searchBar:UISearchBar, textDidChange searchText:String) {
        
        print("[ViewController searchBar] searchText: \(searchText)")
        
        // 没有搜索内容时显示全部内容
        if searchText == "" {
            self.result = self.nameArray
            isSearch = false
            
        } else {
            // 匹配用户输入的前缀，不区分大小写
            self.result = []
            
            for arr in self.nameArray {
                
                //                if arr.hasPrefix(searchText) {
                //                    self.result.append(arr)
                //                }
                if arr.lowercased().hasPrefix(searchText.lowercased()){
                    self.result.append(arr)
                }
            }
            isSearch = true
        }
        
        // 刷新tableView 数据显示
        mainTableView.reloadData()
        
    }
    
    //    3. 点击了书签或其他东西的响应
    
    func searchBarBookmarkButtonClicked(_ searchBar:UISearchBar) {
        
        print("搜索历史")
    }
    
    func searchBarCancelButtonClicked(_ searchBar:UISearchBar) {
        
    }
    
    //点击键盘搜索按钮
    func searchBarSearchButtonClicked(_ searchBar:UISearchBar) {
        
        mainSearchBar.resignFirstResponder()
        
    }
    
    func searchBarResultsListButtonClicked(_ searchBar:UISearchBar) {
        
        
    }
    
    
    
    //    4. 是否开始编辑？返回值false则无响应不开始编辑，是点了那个框的响应
    
    func searchBarShouldBeginEditing(_ searchBar:UISearchBar) ->Bool {
        
        return true
        
    }
    
    func searchBarShouldEndEditing(_ searchBar:UISearchBar) ->Bool {
        
        return true//返回false，则不能结束编辑。即取消第一响应不再起作用
        
    }
    
    
    
    //    5. 开始编辑状态下，开始写搜索内容时，即光标开始闪烁时
    
    func searchBarTextDidBeginEditing(_ searchBar:UISearchBar) {
        
        //        searchBar.text = "1234"
        
        
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar:UISearchBar) {
        
        //        正在输呢，手点了别的地方的响应
        
    }
    
    
    
    //    6. 把输的字处理后显示到框里。false，则输不进去字
    
    func searchBar(_ searchBar:UISearchBar, shouldChangeTextIn range:NSRange, replacementText text:String) ->Bool {
        
        //text就是每次输的一个字符。例如：
        
        if text=="s"{
            
            return false//不让输 s
            
        }
        
        return true
        
    }
    
    
    
    func addModel(){
        
        let student1  = ContactModel()
        student1.name = "f2f"
        
        let student2  = ContactModel()
        student2.name = "hgerg"
        
        let student3  = ContactModel()
        student3.name = "hhet"
        
        let student4  = ContactModel()
        student4.name = "f2hrthf"
        
        let student5  = ContactModel()
        student5.name = "qve"
        
        let student6  = ContactModel()
        student6.name = "acade"
        
        let student7  = ContactModel()
        student7.name = "bcxvw"
        
        let student8  = ContactModel()
        student8.name = "zcs"
        
        let student9  = ContactModel()
        student9.name = "heh"
        
        let student10  = ContactModel()
        student10.name = "mutj"
        
        modelArr = [student1,student2,student3,student4,student5,student6,student7,student8,student9,student10]
        nameArray = [student1.name,student2.name,student3.name,student4.name,student5.name,student6.name,student7.name,student8.name,student9.name,student10.name]
    }


}

