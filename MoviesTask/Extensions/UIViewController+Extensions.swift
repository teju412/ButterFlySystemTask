//
//  UIViewController+Extensions.swift
//  MoviesTask
//
//  Created by TejaDanasvi on 18/10/2023.
//

import UIKit

extension UIViewController {
    func SpinnerFooter() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 32, height: 40))
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.color = .red
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        footerView.backgroundColor = UIColor.white
        return footerView
    }
}

class WorkItem {

private var pendingRequestWorkItem: DispatchWorkItem?

func perform(after: TimeInterval, _ block: @escaping () -> Void) {
    // Cancel the currently pending item
    pendingRequestWorkItem?.cancel()

    // Wrap our request in a work item
    let requestWorkItem = DispatchWorkItem(block: block)

    pendingRequestWorkItem = requestWorkItem

    DispatchQueue.main.asyncAfter(deadline: .now() + after, execute: requestWorkItem)
}
}
