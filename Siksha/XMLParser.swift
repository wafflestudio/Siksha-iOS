//
//  XMLParser.swift
//  Siksha
//
//  Created by 강규 on 2015. 7. 27..
//  Copyright (c) 2015년 WaffleStudio. All rights reserved.
//

import Foundation

class XMLParser: NSObject, NSXMLParserDelegate {
    static let sharedInstance = XMLParser()
    
    var informations: [String: [String]]
    var attribute: String
    var datas: [String]
    
    var count: Int
    var currentElement: String
    var isInItem: Bool
    var sentence: String
    
    private override init() {
        informations = Dictionary<String, [String]>()
        attribute = String()
        datas = []
        
        count = 0
        currentElement = String()
        isInItem = false
        sentence = String()
    }
    
    func parseXMLFile(fileName: String) {
        let parser = NSXMLParser(contentsOfURL: NSBundle.mainBundle().URLForResource(fileName, withExtension: "xml"))
        
        parser!.delegate = self
        parser!.parse()
    }
    
    /* delegate functions */
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName: String?, attributes attributeDict: [NSObject: AnyObject]) {
        self.currentElement = elementName
        
        if elementName == "string-array" {
            attribute = attributeDict["name"] as! String
            datas = []
        }
        else if elementName == "item" {
            isInItem = true
            sentence = ""
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if currentElement == "item" && isInItem {
            sentence += string!
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName: String?) {
        if elementName == "string-array" {
            count += 1
        }
        else if elementName == "item" {
            isInItem = false
            datas.append(sentence.stringByReplacingOccurrencesOfString("\\'", withString: "'"))
            informations[attribute] = datas
        }
    }
    /* end */
}