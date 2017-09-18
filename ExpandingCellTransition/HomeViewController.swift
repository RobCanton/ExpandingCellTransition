//
//  ViewController.swift
//  ExpandingCellTransition
//
//  Created by Robert Canton on 2017-09-16.
//  Copyright © 2017 Robert Canton. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var transitionDelegate = ExpandingNavigationControllerDelegate()
    var selectedIndex:IndexPath!
    
    @IBOutlet weak var tableView: UITableView!
    
    // Mock data
    let homes = [
        Home(title: "Luxury Villa with Amazing Sea View", price: 360, numReviews: 24, image: "0.jpg"),
        Home(title: "Charming, Very Spacious Room with Central Location", price: 180, numReviews: 14, image: "1.jpg"),
        Home(title: "Tropical Beach House", price: 250, numReviews: 5, image: "2.jpg"),
        Home(title: "The Joshua Tree House", price: 125, numReviews: 16, image: "3.jpg"),
        Home(title: "Cozy Cabin with Lake View", price: 90, numReviews: 8, image: "4.jpg"),
        Home(title: "Designer Loft", price: 220, numReviews: 10, image: "5.jpg"),
        Home(title: "Sunny Flat in the Heart of the City", price: 147, numReviews: 18, image: "6.jpg"),
        Home(title: "A Beautiful House in South Africa", price: 405, numReviews: 9, image: "7.jpg"),
        Home(title: "Private Pool House with Amazing Views", price: 550, numReviews: 6, image: "8.jpg")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"

        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ImageTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "imageCell")
        
        tableView.separatorColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        tableView.showsVerticalScrollIndicator = false
        
        tableView.reloadData()
        view.addSubview(tableView)
        
        // Removes navigation bar shadow
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Set navigation delegate to custom transition
        navigationController?.delegate = transitionDelegate

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show navigation bar
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let staticHeight:CGFloat = 8 + 210 + 8 + 4 + 20 + 2 + 15 + 8 + 8
        
        // Estimate height of the title label
        let titleHeight = UILabel.size(withText: homes[indexPath.row].title, forWidth: tableView.frame.width - 48.0, withFont: UIFont.systemFont(ofSize: 22.0, weight: UIFont.Weight.bold)).height
        
        return staticHeight + titleHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! ImageTableViewCell
        
        // Setup cell with home info
        let home = homes[indexPath.row]
        cell.featureImage.image = UIImage(named: home.image)!
        cell.titleLabel.text = home.title
        cell.priceLabel.text = "$\(home.price) per night"
        cell.reviewsLabel.text = "\(home.numReviews) reviews"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        
        // Push detail view controller
        let detailController = DetailViewController()
        detailController.home = homes[indexPath.row]
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .default
        }
    }
}

extension HomeViewController: ExpandingTransitionSourceDelegate {
    
    func transitionDuration() -> TimeInterval {
        return 0.42
    }
    
    func transitionSourceImageView() -> UIImageView {
        let selectedCell = tableView.cellForRow(at: selectedIndex) as! ImageTableViewCell
        return selectedCell.featureImage
    }
    
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect {

        let selectedCell = tableView.cellForRow(at: selectedIndex) as! ImageTableViewCell
        let bounds = selectedCell.featureImage.convert(selectedCell.featureImage.bounds, to: view)
        return bounds
    }
    
    func transitionSourceWillBegin() {
        let selectedCell = tableView.cellForRow(at: selectedIndex) as! ImageTableViewCell
        selectedCell.featureImage.isHidden = true
    }
    
    func transitionSourceDidEnd() {
        let selectedCell = tableView.cellForRow(at: selectedIndex) as! ImageTableViewCell
        selectedCell.featureImage.isHidden = false
    }
    
    func transitionSourceDidCancel() {
        let selectedCell = tableView.cellForRow(at: selectedIndex) as! ImageTableViewCell
        selectedCell.featureImage.isHidden = false
    }
    
    
    func transitionTopSection() -> UIImageView? {
        
        // Create a snapshot of the area above the selected cell
        let cell = tableView.cellForRow(at: selectedIndex)!
        let bounds = cell.convert(cell.bounds, to: view)
        let snapshot = view.snapshot(of: CGRect(x: 0,
                                                y: 0,
                                                width: view.frame.width,
                                                height: bounds.origin.y))
        
        return snapshot
    }
    
    func transitionBottomSection() -> UIImageView? {
        // Create a snapshot of the area below the selected cell
        let cell = tableView.cellForRow(at: selectedIndex)!
        let bounds = cell.convert(cell.bounds, to: view)
        let bottomStart = bounds.origin.y + bounds.height
        let snapshot = view.snapshot(of: CGRect(x: 0,
                                                y: bottomStart,
                                                width: view.frame.width,
                                                height: view.frame.height - bottomStart))
        return snapshot
    }
    
    func transitionMiddleSection() -> UIImageView? {
        // Create a snapshot of the title area below the feature image in the cell
        let cell = tableView.cellForRow(at: selectedIndex)! as! ImageTableViewCell
        var bounds = cell.bottomView.convert(cell.titleArea.bounds, to: view)
        
        if bounds.origin.y > view.bounds.height {
            // If the title area is off-screen, no snapshot is required
            return nil
        } else if bounds.origin.y + bounds.height > view.bounds.height {
            // If the title area is partially off-screen, adjust the frame of the snapshot
            bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: view.bounds.height - bounds.origin.y)
        }

        let snapshot = view.snapshot(of: bounds)
        
        return snapshot
    }
}



