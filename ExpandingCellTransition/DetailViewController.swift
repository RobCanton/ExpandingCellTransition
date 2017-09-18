//
//  DestinationViewController.swift
//  ExpandingCellTransition
//
//  Created by Robert Canton on 2017-09-16.
//  Copyright © 2017 Robert Canton. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView:UITableView!
    var headerView:UIView!
    var headerImageView:UIImageView!
    var closeButton:UIButton!
    
    var home:Home!
    
    let defaultDescription = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesBottomBarWhenPushed = true
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.white
        
        tableView.separatorColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        tableView.showsVerticalScrollIndicator = false
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 250))
        headerImageView = UIImageView(frame: headerView.bounds)
        headerImageView.image = UIImage(named: home.image)
        headerImageView.clipsToBounds = true
        headerImageView.contentMode = .scaleAspectFill
        headerView.addSubview(headerImageView)
        closeButton = UIButton(frame: CGRect(x: 0, y: 8, width: 64, height: 64))
        closeButton.setImage(UIImage(named: "back"), for: .normal)
        closeButton.tintColor = UIColor.white
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        headerView.addSubview(closeButton)
        
        tableView.tableHeaderView = headerView
        
        let nib = UINib(nibName: "TitleTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "titleCell")
        
        let nib2 = UINib(nibName: "DescriptionTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "descCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        view.addSubview(tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Hide close button while transitioning
        closeButton.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show close button after transition
        UIView.animate(withDuration: 0.15, animations: {
            self.closeButton.alpha = 1.0
        })
    }
    
    @objc func handleDismissButton(_ target: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row) {
        case 0:
            // Estimate height of the title label
            let staticHeight:CGFloat = 20 + 8 + 22 + 8 + 20 + 8 + 8
            let titleHeight = UILabel.size(withText: home.title, forWidth: tableView.frame.width - 48.0, withFont: UIFont.systemFont(ofSize: 30.0, weight: UIFont.Weight.bold)).height
            return staticHeight + titleHeight
        case 1:
            // Estimate height of the description label
            return 20 + UILabel.size(withText: defaultDescription, forWidth: tableView.frame.width - 48.0, withFont: UIFont.systemFont(ofSize: 16.0, weight: UIFont.Weight.light)).height
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as! TitleTableViewCell
            cell.titleLabel.text = home.title
            cell.priceLabel.text = "$\(home.price) per night"
            cell.reviewsLabel.text = "\(home.numReviews) reviews"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descCell") as! DescriptionTableViewCell
            cell.descriptionLabel.text = defaultDescription
            return cell
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return UIScreen.main.nativeBounds.height != 2436 // Hide status bar if device is not an iPhone X
        }
    }
}

extension DetailViewController: ExpandingTransitionDestinationDelegate {
    
    func transitionDuration() -> TimeInterval {
        return 0.42
    }
    
    func transitionDestinationImageViewFrame(forward: Bool) -> CGRect {
        let largeImageView = headerImageView!
        let bounds = largeImageView.convert(largeImageView.bounds, to: view)
        if forward {
            return CGRect(x: 0, y: topLayoutGuide.length, width: view.frame.width, height: bounds.height)
        } else {
            return bounds
        }
    }
    
    func transitionDestinationWillBegin() {
        headerImageView.isHidden = true
    }
    
    func transitionDestinationDidEnd() {
        headerImageView.isHidden = false
    }
    
    func transitionDestinationDidCancel() {
        headerImageView.isHidden = false
    }
    
}



