//
//  RecordDetailView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/29/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import URLImage
import FASwiftUI

struct NoteDetailView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @Environment(\.editMode) var mode
    @State var editRecord: Record = Record.Default
    
    var record: Record
    
    func updateRecord() {
        store.send(RecordViewAsyncAction.updateRecord(record: self.editRecord))
    }
    
    var body: some View {
        Group {
            if self.mode?.wrappedValue == .inactive {
                NoteDetailSummary(record: editRecord)
            } else {
                EditNoteView(record: $editRecord)
                .onDisappear {
                    self.updateRecord()
                }
            }
        }.padding(.top, 80).navigationBarItems(trailing: EditButton()).edgesIgnoringSafeArea(.all).onAppear {
            self.editRecord = self.record
        }
    }
}

struct EditNoteView: View {
    @Binding var record: Record
    
    var body: some View {
        
        return ScrollView(.vertical) {
            VStack {
                TextField("Username", text: $record.title).padding()
                MultilineTextField("", text: $record.body, onCommit: {}).padding()
            }

            }.padding(.top, 60).navigationBarTitle(LocalizedStringKey("EditRecord"))

    }
}

struct NoteDetailSummary: View {
    var record: Record
    
    var body: some View {
        let hasImage = record.images_url != nil && record.images_url!.count > 0
        let hasLocation = record.location != nil
        
        return ScrollView(.vertical) {
            VStack(alignment: .leading) {
                Text(record.title).font(.title).fontWeight(.bold).padding()
                Text(record.body).font(.body).padding()
                
                if (hasImage) {
                    
                    ForEach(0..<record.images_url!.count, id:\.self) { index in
                        URLImage(URL(string: self.record.images_url![index])!, placeholder: {
                            ProgressView($0) { progress in
                                ZStack {
                                    if progress > 0.0 {
                                        CircleProgressView(progress).stroke(lineWidth: 8.0)
                                    }
                                    else {
                                        CircleActivityView().stroke(lineWidth: 50.0)
                                    }
                                }
                            }
                            .frame(width: 50.0, height: 50.0)
                        }, content: {
                            $0.image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        })
                    }
                    
                }
                
                if (hasLocation) {
                    LocationCardView(location: record.location!).frame(height: 200).padding()
                }
                
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
        }
    }
}


struct NoteDetailView_Previews: PreviewProvider {
    static var testRecord = Record(title: "Record Title", body: "Record Body", created_by_uid: "Test User")
    
    static var previews: some View {
        testRecord.images_url = ["https://firebasestorage.googleapis.com/v0/b/coffeemaster-7db1d.appspot.com/o/record_images%2F020E61CE-4850-4D4D-A395-6E4988C3BF11.jpg?alt=media&token=a74ade60-839d-4fd6-9a1f-9dd4231f5db7"]
        testRecord.location = Location(coordinate: Location.Coordinate(latitude: 0, longitude: 0), name: "Location", qualifiedName: "Street name")
        
        return NavigationView{
            NoteDetailView(record: testRecord)
        }.modifier(EnvironmemtServices())
    }
}

