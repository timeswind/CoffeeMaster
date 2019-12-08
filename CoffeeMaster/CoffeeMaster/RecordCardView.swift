//
//  RecordCardView.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/24/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import URLImage

struct RecordCardView: View {
    var record: Record!
    
    init(record: Record) {
        self.record = record
    }
    
    var body: some View {
        let recordType = record.recordType ?? .Note
        let hasImage = record.images_url != nil && record.images_url!.count > 0
        let caffeineRecord = record.caffeineRecord
        return VStack {
            if (hasImage) {
                URLImage(URL(string: record.images_url![0])!, placeholder: {
                    ProgressView($0) { progress in
                        ZStack {
                            if progress > 0.0 {
                                // The download has started. CircleProgressView displays the progress.
                                CircleProgressView(progress).stroke(lineWidth: 8.0)
                            }
                            else {
                                // The download has not yet started. CircleActivityView is animated activity indicator that suits this case.
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
            
            if (recordType == .Note) {
                
                HStack {
                    VStack(alignment: .leading) {
                        
                        Text(record.title)
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(Color(UIColor.Theme.Accent))
                            .lineLimit(3)
                        Text("Created at by \(record.created_by_uid)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(100)
                    
                    Spacer()
                }
                .padding()
            }
            
            if (recordType == .Caffeine) {
                HStack {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text(LocalizedStringKey("Caffeine")).foregroundColor(.green).fontWeight(.bold)
                            Spacer()
                            Text(Utilities.convertTimestampShort(date: caffeineRecord!.date.dateValue())).font(.footnote).foregroundColor(.gray)
                        }
                        HStack {
                            Text("\(caffeineRecord!.caffeineEntry.variation[0].displayCaffeineAmount())").font(.title).fontWeight(.bold)
                            Text(LocalizedStringKey("mg")).foregroundColor(.gray)
                        }
                        
                        Spacer().frame(height: 20)
                        
                        Text(LocalizedStringKey(caffeineRecord!.caffeineEntry.category.rawValue)).foregroundColor(Color.Theme.Accent).fontWeight(.bold)
                        Text(LocalizedStringKey(caffeineRecord!.caffeineEntry.name))
                        
                        HStack {
                            Text("\(caffeineRecord!.caffeineEntry.variation[0].displayVolume())")
                            Text(LocalizedStringKey(caffeineRecord!.caffeineEntry.displayVolumeUnit().rawValue))
                        }


                    }
                    .layoutPriority(100)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
            .padding([.top])
    }
}
