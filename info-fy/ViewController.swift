//
//  ViewController.swift
//  info-fy
//
//  Created by Kareem Arab on 2018-07-10.
//  Copyright © 2018 Kareem Arab. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    // MARK: - Properties
    // Outlets
    @IBOutlet weak var provinceTableView: UITableView!
    @IBOutlet weak var yearTableView: UITableView!
    @IBOutlet weak var orderProvButton: UIButton!
    @IBOutlet weak var orderYearButton: UIButton!
    
    var feedDataSource: FeedDataSource?
    var url = "https://shopicruit.myshopify.com/admin/orders.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
    var yearToDisplay = "2017"
    var ind = NVActivityIndicatorView(frame: CGRect(x: (UIScreen.main.bounds.size.width / 2.0) - 50, y: (UIScreen.main.bounds.size.height / 2.0) - 50, width: 100, height: 100), type: .ballPulseSync, color: UIColor.shopifyPurple())

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimations()     
        design()
        setupFeedDataSource()
        load()
    }
    
    // MARK: - Methods
    func design() -> Void {
        self.orderProvButton.layer.cornerRadius = 20
        self.orderYearButton.layer.cornerRadius = 20
        self.orderYearButton.isUserInteractionEnabled = false
        self.orderYearButton.titleLabel?.adjustsFontSizeToFitWidth = true
        //self.orderProvButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    func startAnimations() {
        self.view.addSubview(ind)
        ind.startAnimating()
        orderYearButton.isEnabled = false
    }
    
    func setupFeedDataSource() {
        feedDataSource = FeedDataSource(provinceTableView: provinceTableView, yearTableView: yearTableView)
        provinceTableView.dataSource = feedDataSource
        yearTableView.dataSource = feedDataSource
    }
    
    func setupTableView() {
        provinceTableView.separatorStyle = .none
        yearTableView.separatorStyle = .none
    }
    
    func load() {
        self.feedDataSource?.doStuff(self.url, yearToDisplay: self.yearToDisplay, ind: ind, completion: { (yearOrders) in
            self.orderYearButton.titleLabel?.text = "Orders in \(self.yearToDisplay): \(yearOrders.count)"
            //self.orderProvButton.titleLabel?.text = "Orders by Province"
        })
    }
    
    // Removes status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func provinceButton(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "provinceViewController") as! ProvinceViewController
        self.present(controller, animated: true, completion: nil)
    }
    
}
