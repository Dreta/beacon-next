import SwiftUI
import QMapKit

struct BeaconHomeView: View {
    @EnvironmentObject var locationManager: BeaconLocationDelegateSimple
    @EnvironmentObject var navManager: BeaconNavigationDelegateSimple
    
    @State private var isShowingSearch = false
    
    @State private var isShowingRoutes = false
    @State private var from: QMSPoiData? // If nil, use current location; otherwise, use the selected POI
    @State private var destination: QMSPoiData?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Image(systemName: "location.fill")
                                .accessibilityHidden(true)
                            Text(locationManager.lastAddress ?? "Loading...") // Current Location
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Current Location: \(locationManager.lastAddress ?? "Loading...")")

                        Button(action: {
                            isShowingSearch = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.secondary)
                                Text("Search for a place or address")
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(8)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.secondary.opacity(0.2))
                        )
                        .accessibilityLabel("Search")
                        .accessibilityAddTraits(.isSearchField)
                        .accessibilityHint("Tap to open search")
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Favorites")
                        .font(.title2)
                        .bold()
                    HStack(spacing: 16) {
                        FavoriteView(
                            text: "Home",
                            subtitle: "Close by",
                            fullSubtitle: "Close by",
                            icon: "house.circle.fill"
                        )
                        FavoriteView(
                            text: "School",
                            subtitle: "31m",
                            fullSubtitle: "31 minutes",
                            icon: "graduationcap.circle.fill"
                        )
                        FavoriteView(
                            text: "World",
                            subtitle: "999h",
                            fullSubtitle: "999 hours",
                            icon: "mappin.circle.fill"
                        )
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Welcome to Beacon")
                            .font(.title2)
                            .bold()
                        Text("A set of notes to help you get started")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    VStack(alignment: .leading, spacing: 16) {
                        CardView(
                            title: "Latest Features",
                            text: "Android support, road orientation, and more!",
                            color: .cyan
                        )
                        CardView(
                            title: "New to Beacon?",
                            text: "Start a tutorial to learn about how easy Beacon is.",
                            color: .blue
                        )
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingSearch) {
            BeaconSearchView(isPresented: $isShowingSearch) { poi in
                self.from = nil
                self.destination = poi
                self.isShowingRoutes = true
            }
        }
        .sheet(isPresented: $isShowingRoutes) {
            BeaconRouteSelectionView(from: $from, destination: $destination, isPresented: $isShowingRoutes)
        }
        .padding()
        .navigationTitle("Beacon")
        .navigationBarTitleDisplayMode(.large)
        .onChange(of: navManager.isNavigating){
            if !navManager.isNavigating {
                isShowingRoutes = false
                isShowingSearch = false
            }
        }
    }
}
//
//#Preview {
//    BeaconHomeView()
//}
