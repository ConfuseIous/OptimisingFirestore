//
//  ContentView.swift
//  OptimisingFirestore
//
//  Created by Karandeep Singh on 24/4/23.
//

import SwiftUI

struct ContentView: View {
	
	@ObservedObject var listingViewModel = ListingViewModel()
	
	var formatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		formatter.timeStyle = .short
		formatter.calendar = Calendar(identifier: .iso8601)
		
		return formatter
	}
	
	var body: some View {
		NavigationStack {
			VStack {
				VStack(spacing: 10) {
					Text("Total Items in Array: ")
						.frame(maxWidth: .infinity, alignment: .leading)
					Text("From JSON: ")
						.frame(maxWidth: .infinity, alignment: .leading)
					Text("From Firestore: ")
						.frame(maxWidth: .infinity, alignment: .leading)
					Text("Fetched At: ")
						.frame(maxWidth: .infinity, alignment: .leading)
				}.padding()
				List {
					ForEach(listingViewModel.listings) { listing in
						VStack {
							HStack(alignment: .center) {
								Text(listing.title)
									.font(.system(size: 20))
									.bold()
								Spacer()
								Text(formatter.string(from: listing.lastUpdated))
									.font(.system(size: 14))
									.foregroundColor(.secondary)
							}
							Text(listing.content)
								.frame(maxWidth: .infinity, alignment: .leading)
								.font(.system(size: 16))
								.padding()
								.background(Color(uiColor: .secondarySystemBackground))
						}.cornerRadius(10)
					}
				}
				.listStyle(InsetListStyle())
				.refreshable {
					await listingViewModel.getListings()
				}
			}
			.padding()
			.onAppear {
				Task {
					await listingViewModel.getListings()
				}
			}
			.navigationTitle("Optimising Firestore")
		}
	}
}
