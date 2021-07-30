//
//  PhotoDatasource.swift
//  photo-list-tableview
//
//  Created by Mark bergeson on 7/27/21.
//

import Foundation

protocol PhotoDatasourceDelegate: AnyObject {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
  func onFetchFailed(with reason: String)
}

class PhotoDatasource {
  weak var delegate: PhotoDatasourceDelegate?
  
  private var photos = [PhotoList]()
  var currentPage = 1
  private var total = 1000
  private var isFetchInProgress = false
    private var needsRefresh = false
  
  var totalCount: Int {
    return total
  }
  
  var currentCount: Int {
    return photos.count
  }
  
    func photo(at index: Int) -> PhotoList {
    return photos[index]
  }
  
    func refreshPhotos() {
        if isFetchInProgress {
        needsRefresh = true
        } else {
            self.photos.removeAll()
            currentPage = 1
            fetchPhotos()
        }
    }
    
  func fetchPhotos() {
    
    guard !isFetchInProgress else {
      return
    }
    
    isFetchInProgress = true
    
    API.shared.getPhotoData(page: currentPage) { result in
        guard let response = result else {
            self.isFetchInProgress = false
            self.delegate?.onFetchFailed(with: "Error")
            return
        }
        
        self.currentPage += 1
        self.isFetchInProgress = false
        if self.needsRefresh {
            self.needsRefresh = false
            self.photos.removeAll()
            self.currentPage = 1
            self.fetchPhotos()
        } else {
            self.photos.append(contentsOf: response)
            let indexPathsToReload = self.calculateIndexPathsToReload(from: response)
            self.delegate?.onFetchCompleted(with: indexPathsToReload)
        }
    }
  }
  
  private func calculateIndexPathsToReload(from newPhotos: [PhotoList]) -> [IndexPath] {
    let startIndex = photos.count - newPhotos.count
    let endIndex = startIndex + newPhotos.count
    return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
  }
  
}

