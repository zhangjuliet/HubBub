// Copyright 2023 Esri
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import SwiftUI

import ArcGIS

@main
struct HubBubApp: App {
    
    init() {
        ArcGISEnvironment.apiKey = APIKey("your_API_key")
    }
    
    var body: some SwiftUI.Scene {
        WindowGroup {
            TabView {
//                NavigateRouteView()
//                    .tabItem {
//                        Label("Route", systemImage: "hand.wave.fill")
//                    }
//                }
            
//            SearchWithGeocodeView()
//                .tabItem {
//                    Label("Search", systemImage: "search.fill")
//                }
//
                    ContentView()
                        .tabItem {
                            Label("Map", systemImage: "map.fill")
                        }

                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "dial.fill")
                        }
//
                }
        }
    }
    
}
