//
//  ViewController.swift
//  GetYourReviewsApp
//
//  Created by Smriti on 01.12.20.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{

    private var apicaller = ReviewService()
    private var limit: Int = 10
    private var page: Int = 0
    private var offset: Int = 0
    
    @IBOutlet weak var tableBackgroundView: UIView!
    
    @IBOutlet weak var ratingButton: UIButton!
    
    @IBOutlet weak var dateButton: UIButton!
    var activityIndView: UIActivityIndicatorView?
    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        return tableview
    }()
    
    private var reviewArray = [ReviewViewModel]()
    private var sortingOption: String = "rating"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableBackgroundView.addSubview(tableView)
        addInitialLoadingActivityInd()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setUpTableView()
        getReviewsForInitialLoad(pagination: true, sortOption: sortingOption, limit: self.limit, offset: self.offset)
    }
    //MARK: - IBoutlet actions

    @IBAction func sortByRating(_ sender: UIButton) {
        sortingOption = "rating"
        self.ratingButton.setTitle("High Rating", for: .normal)
        self.dateButton.setTitle("Date", for: .normal)

        page = 0
        self.offset = self.page * self.limit
        addInitialLoadingActivityInd()
        self.reviewArray.removeAll()
        getReviewsForInitialLoad(pagination: true, sortOption: sortingOption, limit: self.limit, offset: self.offset)
    }
    
    @IBAction func sortByDate(_ sender: UIButton) {
        sortingOption = "date"
        self.dateButton.setTitle("Newest", for: .normal)
        self.ratingButton.setTitle("Rating", for: .normal)

        loadReviewsBySelectedSortOption()

    }
    
    func displayAlert(title: String,message: String){
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel" , style: .cancel)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - private functions

    fileprivate func loadReviewsBySelectedSortOption() {
        page = 0
        self.offset = self.page * self.limit
        addInitialLoadingActivityInd()
        self.reviewArray.removeAll()
        getReviewsForInitialLoad(pagination: true, sortOption: sortingOption, limit: self.limit, offset: self.offset)
    }

    fileprivate func getReviewsForInitialLoad(pagination:Bool,sortOption: String, limit: Int, offset: Int) {
        apicaller.fetchReviewsFor(pagination:pagination,sortOption: sortOption, limit: limit, offset: page * limit, completion: { [weak self] result in
            DispatchQueue.main.async { [self] in
                self!.activityIndView!.stopAnimating()
                switch result {
                case .success(let fetchedData):
                    self?.reviewArray = (fetchedData.reviews?.map({return ReviewViewModel(review: $0)}))!
                    self?.tableView.reloadData()
                case .failure(let error):
                    var errorMessage = error.localizedDescription
                    if let customErr = error as? ReviewServiceCustomError{
                        errorMessage = customErr.errorDescription!
                    }
                    self?.displayAlert(title: "An error occured", message: errorMessage)
                }
            }
            
        })
    }

    fileprivate func setUpTableView() {
        tableView.frame = view.bounds
        tableView.register(UINib(nibName: "ReviewCell", bundle: Bundle.main), forCellReuseIdentifier: Constants.reviewCellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
    }

    fileprivate func addInitialLoadingActivityInd() {
        activityIndView = self.createSpinnerFor(self.view)
        self.view.addSubview(activityIndView!)
    }

    fileprivate func createSpinnerFor(_ view: UIView) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        spinner.style = .medium
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }
    
    private func createFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        footerView.addSubview(createSpinnerFor(footerView))
        return footerView
        
    }
}
//MARK: - TableView and Scrollview Delegate functions

extension ViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reviewCellId) as! ReviewCell
        cell.reviewViewModel = reviewArray[indexPath.row]
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y

        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            //fetch more
            guard !apicaller.isPaginating else {
                //We are already fetching more data
                return
            }
            self.tableView.tableFooterView = createFooterView()
            self.page = self.page+1
            self.offset = self.page * self.limit
            apicaller.fetchReviewsFor(pagination: true,sortOption: sortingOption, limit: self.limit, offset: self.offset, completion:{ [weak self] result in
                    DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                    }
                    switch result {
                    case .success(let moreData):
                        let reviewVMArray = (moreData.reviews?.map({return ReviewViewModel(review: $0)}))!
                        self?.reviewArray.append(contentsOf: reviewVMArray)
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                    }
                    case .failure(let error):
                        self?.displayAlert(title: "An error occured", message: error.localizedDescription)
                    }
                })

    }
    }
}

