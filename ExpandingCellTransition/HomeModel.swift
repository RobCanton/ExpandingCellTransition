//
//  HomeModel.swift
//  ExpandingCellTransition
//
//  Created by Robert Canton on 2017-09-16.
//  Copyright © 2017 Robert Canton. All rights reserved.
//

import Foundation

class Home {
    
    private(set) var title:String
    private(set) var price:Int
    private(set) var numReviews:Int
    private(set) var image:String
    
    init(title:String, price:Int, numReviews:Int, image:String)
    {
        self.title = title
        self.price = price
        self.numReviews = numReviews
        self.image = image
    }
}
