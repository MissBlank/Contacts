//
//  ContactList.swift
//  LeftSide
//
//  Created by NERC on 2018/6/29.
//  Copyright © 2018年 GaoNing. All rights reserved.
//

import UIKit

class ContactList: NSObject {


    
    public class func getOrderContacts(modelArray:[ContactModel]) ->(contentDic:[String:[ContactModel]],nameKeys:Array<String>) {
        
        var contentDict = [String:[ContactModel]]()
        var nameKeys = Array(contentDict.keys)

//        let queue = DispatchQueue(label: "content")
//        queue.async {
        
            for model in modelArray {
//                print("\(model.name)")
                //获取到姓名的大写首字母
                let firstLetterString = getFirstLetterFromString(aString: model.name)

                
                if contentDict[firstLetterString] != nil{
                    
                    contentDict[firstLetterString]?.append(model)
                }
                else{
                    var arrGroupNames = Array<ContactModel>()
                    arrGroupNames.append(model)
                    
                    contentDict[firstLetterString] = arrGroupNames

                }
            }
        
        //将contentDic所有的key进行排序
             nameKeys = Array(contentDict.keys).sorted()
            
            if nameKeys.first == "#"{
                nameKeys.insert(nameKeys.first!, at: nameKeys.count)
                nameKeys.remove(at: 0)
            }
            

        return (contentDict,nameKeys)
    }
    
    
        
    
    
    
    private class func getFirstLetterFromString(aString:String) -> (String){
        //这里必须切换到可变字符串
        let mutableString = NSMutableString.init(string: aString)
        //将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        //去掉声调（提高遍历速度）
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        //将拼音首字母换成大写
        let strPinYin = polyphoneString(nameString: aString, pinyinString: pinyinString).uppercased()
        //截取大写字母
        let firstString = strPinYin.substring(to: strPinYin.index(strPinYin.startIndex, offsetBy: 1))
        //判断姓名首字母是否为大写
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        
        return predA.evaluate(with: firstString) ? firstString : "#"
        
    }
    
    
    //多音字处理
    private class func polyphoneString(nameString:String,pinyinString:String) -> String{
        if nameString.hasPrefix("长") {return "chang"}
        if nameString.hasPrefix("沈") {return "shen"}
        if nameString.hasPrefix("厦") {return "xia"}
        if nameString.hasPrefix("地") {return "di"}
        if nameString.hasPrefix("重") {return "chong"}
        
        return pinyinString;
    }
    
}
