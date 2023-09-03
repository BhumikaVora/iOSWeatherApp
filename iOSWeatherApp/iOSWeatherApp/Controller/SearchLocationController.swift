//
//  SearchLocationController.swift
//  Created by Bhumika on 31/08/23.
//

import UIKit

class SearchLocationController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!
    
    var locationData = [Location]()
    var callback : ((Location) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationTableView.delegate = self
        locationTableView.dataSource = self
        searchBar.delegate = self
    }
    
    public func searchForLocation() {
        guard let searchText = searchBar.text else { return }

        WeatherAPIClient().searchLocation(searchText: searchText) { locations, error in
            guard let locations = locations else { return }

            self.locationData = locations
            
            Async.main({ [weak self] in
                guard let strongSelf = self else { return }
               
                strongSelf.locationTableView.reloadData()
            })
        }
    }
    
    @IBAction func btnBackAction(button: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func showNoInternetToast(){
        AppSnackBar.make(
            in: self.view,
            message: AppConstant.InternetConnectionMessage,
            duration: .lengthLong)
        .setAction(
            with: AppConstant.Retry,
            action: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.searchForLocation()
        }).show()
    }

}

extension SearchLocationController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = locationTableView.dequeueReusableCell(withIdentifier: AppConstant.LocationCell, for: indexPath) as? LocationCell
        else { return UITableViewCell() }

        let locationObj = locationData[indexPath.row]
        let locationTitle = "\(locationObj.name), \(locationObj.state ?? ""), \(locationObj.country ?? "")"
        cell.lblLocation.text = locationTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)

        let locationObj = locationData[indexPath.row]
        callback?(locationObj)
        navigationController?.popViewController(animated: true)
    }
}

extension SearchLocationController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if Reachability.isConnectedToNetwork() {
            self.searchForLocation()
        }
        else {
            self.showNoInternetToast()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
