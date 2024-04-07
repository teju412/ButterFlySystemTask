//
//  MovieViewController.swift
//  MoviesTask
//
//  Created by TejaDanasvi on 18/10/2023.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    var viewModel: MoviesViewModel = MoviesViewModel()
    lazy var workItem = WorkItem()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movies"
        searchBar.delegate = self
        registerNib()
        viewModel.load {
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
        print("Git working Here but I'm trying to void the data model in view")
    }
    
    func registerNib() {
        let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "MovieTableViewCell")
    }
}

extension MovieViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        let movie =  viewModel.movies[indexPath.row]
        cell.configure(movie: movie)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MovieDetailsView") as! MovieDetailsViewController
        controller.movie = viewModel.movies[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension MovieViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        guard !viewModel.isLoading else { return }
        if position > (self.tblView.contentSize.height - 100 - scrollView.frame.size.height){
            if self.tblView.contentSize.height > UIScreen.main.bounds.size.height {
                self.tblView.tableFooterView = SpinnerFooter()
            }
            viewModel.load {
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }
    }
}

extension MovieViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, text.count > 1 {
            viewModel.searchText = text
            workItem.perform(after: 0.5) { [self] in
                viewModel.search() {
                    self.tblView.reloadData()
                }
            }
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let text = searchBar.text {
            viewModel.searchText = text
            workItem.perform(after: 0.5) { [self] in
                viewModel.search() {
                    self.tblView.reloadData()
                }
            }
        }
    }
}
