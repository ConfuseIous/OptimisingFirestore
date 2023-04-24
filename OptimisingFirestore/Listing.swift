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
}
