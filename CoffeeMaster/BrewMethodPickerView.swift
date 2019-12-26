//
//  BrewMethodPickerView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 12/14/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI

struct BrewMethodPickerView: View {
    var methods: [BrewMethod]
    @Binding var selectedBrewMethod: BrewMethod
    
    @State var brewMethodSelected:  BrewMethod?
    
    init(methods: [BrewMethod], selectedBrewMethod:Binding<BrewMethod>) {
        self.methods = methods
        self._selectedBrewMethod = selectedBrewMethod
        self.brewMethodSelected = selectedBrewMethod.wrappedValue
    }
    
    func select(_ brewMethod: BrewMethod) {
        self.selectedBrewMethod = brewMethod
        self.brewMethodSelected = brewMethod
    }

    var body: some View {

        return  ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .bottom, spacing: 40) {
                ForEach(methods, id: \.name) { brewMethod in
                    GeometryReader { geometry in
                        VStack {
                            Image("\(brewMethod.baseBrewMethodType.rawValue)-icon").resizable().scaledToFit().frame(width: 106.0, height: 106.0)
                                .aspectRatio(CGSize(width:100, height: 100), contentMode: .fit)
                            Text(brewMethod.name).foregroundColor(self.brewMethodSelected?.name == brewMethod.name ? Color.white : Color.black).fontWeight(.bold)
                            
                        }.padding()
                            .background(self.brewMethodSelected?.name == brewMethod.name ? Color.Theme.Accent : Color.Theme.LightGrey)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.3),
                                    radius: 3,
                                    x: 3,
                                    y: 3)
                            .onTapGesture {
                                self.select(brewMethod)
                        }
                            .rotation3DEffect(Angle(degrees: (Double(geometry.frame(in: .global).minX) - 40) / -20), axis: (x: 0, y: 10, z: 0))
                    }
                }.frame(width: 100, height: 246).padding(.leading, 40)
                Text("").frame(width: 200)
            }
        }
    }
}


struct BrewMethodPickerView_Previews: PreviewProvider {
    static var defaultBrewMethods = StaticDataService.defaultBrewMethods
    @State static var selectedBrewMethod = StaticDataService.defaultBrewMethods.first!
    
    static var previews: some View {
        return BrewMethodPickerView(methods: defaultBrewMethods, selectedBrewMethod: $selectedBrewMethod).modifier(EnvironmemtServices())
    }
}
