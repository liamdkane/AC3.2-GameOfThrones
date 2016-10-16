//
//  Episodes.swift
//  AC3.2-GameOfThrones
//
//  Created by C4Q on 10/13/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class GOTEpisode {
    let name: String
    let number: Int
    let airdate: String
    let summary: String
    let image: String
    let season: Int
    
    init(name: String, number: Int, airdate: String, summary: String, image: String, season: Int) {
        self.name = name
        self.number = number
        self.airdate = airdate
        self.summary = summary
        self.image = image
        self.season = season
    }
    
    convenience init?(withDict dict: [String:Any]) {
        if let name = dict["name"] as? String,
            let number = dict["number"] as? Int,
            let airdate = dict["airdate"] as? String,
            let summary = dict["summary"] as? String,
            let image = dict["image"] as? [String:String],
            let season = dict["season"] as? Int{
            if let originalImage = image["original"] {
                self.init(name: name, number: number, airdate: airdate, summary: summary, image: originalImage, season: season)
            } else {
                return nil
            }
        }
        else {
            return nil
        }
    }
}
