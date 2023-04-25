//
//  ListingViewModel.swift
//  OptimisingFirestore
//
//  Created by Karandeep Singh on 24/4/23.
//

import Firebase

@MainActor
class ListingViewModel: ObservableObject {
	
	@Published var localDataCount = 0
	@Published var remoteDataCount = 0
	@Published var listings: [Listing] = []
	
	func getListings() async {
		do {
			let result = try await Firestore.firestore().collection("listings")
				.whereField("lastUpdated", isGreaterThan: UserDefaults.standard.object(forKey: "lastUpdatedDate") as? Date ?? Date(timeIntervalSince1970: 0))
				.getDocuments()

			var listings: [Listing] = []
			var localListings = (Listing.loadFromFile() ?? [])

			for document in result.documents {
				let documentData = document.data()

				if documentData["isDeleted"] as? Bool == true {
					// Remove deleted listings from the local cache
					localListings.removeAll(where: {$0.id == documentData["id"] as? String})
				} else {
					listings.append(Listing(
						id: documentData["id"] as? String ?? "",
						title: documentData["title"] as? String ?? "",
						content: documentData["content"] as? String ?? "",
						lastUpdated: (documentData["lastUpdated"] as? Timestamp)?.dateValue() ?? Date())
					)
				}
			}

			self.localDataCount = localListings.count
			self.remoteDataCount = listings.count

			localListings = localListings.filter({
				// Remove listings for which updated data is available
				let listing = $0
				return !listings.contains(where: {$0.id == listing.id})
			})

			listings.append(contentsOf: localListings)

			self.listings = listings

			Listing.saveToFile(listings: listings)

			UserDefaults.standard.set(Date(), forKey: "lastUpdatedDate")
		} catch {
			print(error)
		}
	}
}
