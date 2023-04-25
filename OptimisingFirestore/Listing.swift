//
//  Listing.swift
//  OptimisingFirestore
//
//  Created by Karandeep Singh on 24/4/23.
//

import Foundation

struct Listing: Identifiable, Codable {
	var id: String
	var title: String
	var content: String
	var lastUpdated: Date
	
	// MARK: - Saving To Local plist
	// You don't necessarily need to do this. Use whatever local storage method works best for you.
	// For apps with larger caches (ie anything with infinite scroll), you should NOT be saving to plists.
	
	static var archiveURL: URL {
		return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Listings.plist")
	}
	
	static func saveToFile(listings: [Listing]) {
		let propertyListEncoder = PropertyListEncoder()
		let encodedListings = try? propertyListEncoder.encode(listings)
		try! encodedListings!.write(to: archiveURL, options: .noFileProtection)
	}
	
	static func loadFromFile() -> [Listing]? {
		let propertyListDecoder = PropertyListDecoder()
		
		guard let retrievedListingData = try? Data(contentsOf: archiveURL) else { return nil }
		guard let decodedListings = try? propertyListDecoder.decode(Array<Listing>.self, from: retrievedListingData) else { return nil }
		
		return decodedListings
	}
}
