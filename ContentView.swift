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

struct ContentView: View {
    @State private var showBikeRacks = true

    @State private var map = {
        let map = Map(basemapStyle: .arcGISTopographic)

        map.initialViewpoint = Viewpoint(latitude: 45.5152, longitude: -122.6784, scale: 72_000)

        return map
    }()

    private func makeFeatureLayer(url: URL) -> FeatureLayer {
        let serviceFeatureTable = ServiceFeatureTable(url: url)
        let featureLayer = FeatureLayer(featureTable: serviceFeatureTable)
        return featureLayer
    }
    
    private func addBikeRacks() {
        let featureLayer = makeFeatureLayer(url: .portlandBikeRacks)
        
        let pictureMarkerSymbol = PictureMarkerSymbol(url: .bikeRackImage)
        pictureMarkerSymbol.height = 18.0
        pictureMarkerSymbol.width = 18.0
        let simpleRenderer = SimpleRenderer(symbol: pictureMarkerSymbol)
        featureLayer.renderer = simpleRenderer
        featureLayer.labelsAreEnabled = true
        let trailHeadsDefinition = makeLabelDefinition()
        featureLayer.addLabelDefinition(trailHeadsDefinition)
    
        // Adds the feature layer to the map.
        map.addOperationalLayer(featureLayer)
    }
    
    private func addBikeRoutes() {
        let featureLayer = makeFeatureLayer(url: .portlandBikeRoutes)
        
        // Creates and assigns a simple renderer to the feature layer.
        let bikeTrailSymbol = SimpleLineSymbol(style: .dot, color: .blue, width: 2.0)
        let bikeTrailRenderer = SimpleRenderer(symbol: bikeTrailSymbol)
        featureLayer.renderer = bikeTrailRenderer
        // Adds the feature layer to the map.
        map.addOperationalLayer(featureLayer)
    }

    private func makeOpenSpaceLayer() {
        // Creates a parks and open spaces feature layer.
        let featureLayer = makeFeatureLayer(url: .parksAndOpenSpaces)
        
        // Creates fill symbols.
        let purpleFillSymbol = SimpleFillSymbol(style: .solid, color: .purple, outline: .none)
        let greenFillSymbol = SimpleFillSymbol(style: .solid, color: .green, outline: .none)
        let blueFillSymbol = SimpleFillSymbol(style: .solid, color: .blue, outline: .none)
        let redFillSymbol = SimpleFillSymbol(style: .solid, color: .red, outline: .none)

        // Creates a unique value for natural areas, regional open spaces, local parks & regional recreation parks.
        let naturalAreas = UniqueValue(description: "Natural Areas", label: "Natural Areas", symbol: purpleFillSymbol, values: ["Natural Areas"])
        let regionalOpenSpace = UniqueValue(description: "Regional Open Space", label: "Regional Open Space", symbol: greenFillSymbol, values: ["Regional Open Space"])
        let localPark = UniqueValue(description: "Local Park", label: "Local Park", symbol: blueFillSymbol, values: ["Local Park"])
        let regionalRecreationPark = UniqueValue(description: "Regional Recreation Park", label: "Regional Recreation Park", symbol: redFillSymbol, values: ["Regional Recreation Park"])

        // Creates and assigns a unique value renderer to the feature layer.
        let openSpacesUniqueValueRenderer = UniqueValueRenderer(fieldNames: ["TYPE"], uniqueValues: [naturalAreas, regionalOpenSpace, localPark, regionalRecreationPark], defaultLabel: "Open Spaces", defaultSymbol: .none)
        featureLayer.renderer = openSpacesUniqueValueRenderer

        // Sets the layer opacity to semi-transparent.
        featureLayer.opacity = 0.2
        // Adds the feature layer to the map.
        map.addOperationalLayer(featureLayer)
    }

    private func addTrailsLayer() {
        // Creates a trails feature layer.
        let featureLayer = makeFeatureLayer(url: .trails)

        // Creates simple line symbols.
        let firstClassSymbol = SimpleLineSymbol(style: .solid, color: .purple, width: 3.0)
        let secondClassSymbol = SimpleLineSymbol(style: .solid, color: .purple, width: 4.0)
        let thirdClassSymbol = SimpleLineSymbol(style: .solid, color: .purple, width: 5.0)
        let fourthClassSymbol = SimpleLineSymbol(style: .solid, color: .purple, width: 6.0)
        let fifthClassSymbol = SimpleLineSymbol(style: .solid, color: .purple, width: 7.0)

        // Creates 5 class breaks.
        let firstClassBreak = ClassBreak(description: "Under 500", label: "0 - 500", minValue: 0.0, maxValue: 500.0, symbol: firstClassSymbol)
        let secondClassBreak = ClassBreak(description: "501 to 1000", label: "501 - 1000", minValue: 501.0, maxValue: 1000.0, symbol: secondClassSymbol)
        let thirdClassBreak = ClassBreak(description: "1001 to 1500", label: "1001 - 1500", minValue: 1001.0, maxValue: 1500.0, symbol: thirdClassSymbol)
        let fourthClassBreak = ClassBreak(description: "1501 to 2000", label: "1501 - 2000", minValue: 1501.0, maxValue: 2000.0, symbol: fourthClassSymbol)
        let fifthClassBreak = ClassBreak(description: "2001 to 2300", label: "2001 - 2300", minValue: 2001.0, maxValue: 2300.0, symbol: fifthClassSymbol)
        let elevationBreaks = [firstClassBreak, secondClassBreak, thirdClassBreak, fourthClassBreak, fifthClassBreak]

        // Creates and assigns a class breaks renderer to the feature layer.
        let elevationClassBreaksRenderer = ClassBreaksRenderer(fieldName: "ELEV_GAIN", classBreaks: elevationBreaks)
        featureLayer.renderer = elevationClassBreaksRenderer

        // Sets the layer opacity to semi-transparent.
        featureLayer.opacity = 0.75
        // Adds the feature layer to the map.
        map.addOperationalLayer(featureLayer)
    }

    private func addBikeOnlyTrailsLayer() {
        // Creates a trails feature layer.
        let featureLayer = makeFeatureLayer(url: .bikesTrails)

        // Writes a definition expression to filter for trails that do permit the use of bikes.
        featureLayer.definitionExpression = "USE_BIKE = 'Yes'"

        // Creates and assigns a simple renderer to the feature layer.
        let bikeTrailSymbol = SimpleLineSymbol(style: .dot, color: .blue, width: 2.0)
        let bikeTrailRenderer = SimpleRenderer(symbol: bikeTrailSymbol)
        featureLayer.renderer = bikeTrailRenderer
        // Adds the feature layer to the map.
        map.addOperationalLayer(featureLayer)
    }

    private func addNoBikeTrailsLayer() {
        // Creates a no bike trails feature layer.
        let featureLayer = makeFeatureLayer(url: .bikesTrails)
        // Writes a definition expression to filter for trails that don't permit the use of bikes.
        featureLayer.definitionExpression = "USE_BIKE = 'No'"

        // Creates and assigns a simple renderer to the feature layer.
        let noBikeTrailSymbol = SimpleLineSymbol(style: .dot, color: .red, width: 2.0)
        let noBikeTrailRenderer = SimpleRenderer(symbol: noBikeTrailSymbol)
        featureLayer.renderer = noBikeTrailRenderer
        // Adds the feature layer to the map.
        map.addOperationalLayer(featureLayer)
    }

    private func makeLabelDefinition() -> LabelDefinition {
        let trailHeadsTextSymbol = TextSymbol()
        trailHeadsTextSymbol.color = .white
        trailHeadsTextSymbol.size = 20.0
        trailHeadsTextSymbol.haloColor = .red
        trailHeadsTextSymbol.haloWidth = 2.0
        trailHeadsTextSymbol.fontFamily = "Noto Sans"
        trailHeadsTextSymbol.fontStyle = .italic
        trailHeadsTextSymbol.fontWeight = .normal

        // Makes an arcade label expression.
        let expression = "$feature.TRL_NAME"
        let arcadeLabelExpression = ArcadeLabelExpression(arcadeString: expression)
        let labelDefinition = LabelDefinition(labelExpression: arcadeLabelExpression, textSymbol: trailHeadsTextSymbol)
        labelDefinition.placement = .pointAboveCenter

        return labelDefinition
    }

    private func addTrailheadsLayer() {
        // Creates a trailheads feature layer.
        let featureLayer = makeFeatureLayer(url: .trailheads)

        let pictureMarkerSymbol = PictureMarkerSymbol(url: .trailheadImage)
        pictureMarkerSymbol.height = 18.0
        pictureMarkerSymbol.width = 18.0
        let simpleRenderer = SimpleRenderer(symbol: pictureMarkerSymbol)
        featureLayer.renderer = simpleRenderer
        featureLayer.labelsAreEnabled = true
        let trailHeadsDefinition = makeLabelDefinition()
        featureLayer.addLabelDefinition(trailHeadsDefinition)
        // Adds the feature layer to the map.
        map.addOperationalLayer(featureLayer)
    }

    var body: some View {
        
        VStack {
            MapView(map: map).task {
                
                makeOpenSpaceLayer()
                
                if showBikeRacks {
                    addBikeRacks()
                }
                
                addBikeRoutes()
                
                //                addTrailsLayer()
                //
                //                addNoBikeTrailsLayer()
                //                addBikeOnlyTrailsLayer()
                //
                //                addTrailheadsLayer()
            }
                Button(action: {
                    showBikeRacks.toggle()
                    print(showBikeRacks)
                }, label: {
                    Text(showBikeRacks ? "Hide bike racks" : "Show bike racks")
                })

            }

    }

}


