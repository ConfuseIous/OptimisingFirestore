//
//  ListingViewModel.swift
//  OptimisingFirestore
//
//  Created by Karandeep Singh on 24/4/23.
//

import Firebase

@MainActor
class ListingViewModel: ObservableObject {
	
	@Published var listings: [Listing] = []
	
	func getListings() async {
		do {
			let result = try await Firestore.firestore().collection("listings").getDocuments()
			
			var listings: [Listing] = []
			
			for document in result.documents {
				let documentData = document.data()
				listings.append(Listing(
					id: documentData["id"] as? String ?? "",
					title: documentData["title"] as? String ?? "",
					content: documentData["content"] as? String ?? "",
					lastUpdated: (documentData["lastUpdatedDate"] as? Timestamp)?.dateValue() ?? Date())
				)
			}
			
			self.listings = listings
		} catch {
			print(error)
		}
	}
}
