//
//  iDeskChatUIView.swift
//  LibrayTestProject
//
//  Created by Bijoy  Debnath on 24/9/23.
//

import SwiftUI

public struct iDeskChatUIView: View {
    
    @StateObject var dataFetcher = DataFetcher()
    
    var ideskAppData: IdeskAppData?
    
    public init(ideskAppData: IdeskAppData?){
        
        self.ideskAppData = ideskAppData
//        var cusDictionary =  [String: Any]()
//        cusDictionary["name"] = "kamal"
//        cusDictionary["rmn"] = "019667653443"
//
//
//        var miscellaneousDic =  [String: Any]()
//        miscellaneousDic["float"] = 0
//
//         ideskAppData = IdeskAppData(resource_uri: "toolstatic.idesk360.com", app_uri: "tool.idesk360.com", page_id: "1694592792000", customerInfo: cusDictionary, miscellaneousDic: miscellaneousDic)
        
    }
    public var body: some View {
        
        ZStack{
            if dataFetcher.isLoading {
                VStack(spacing: 20)  {
                    ProgressView()
                    Text("Loading")
                        .foregroundColor(.gray)
                    
                }
            } else if dataFetcher.errorMessage != nil{
                VStack {
                    
                    Image(systemName: "xmark.octagon.fill").resizable().foregroundColor(.black).frame(width: 60, height: 60)
                    
                    Text(dataFetcher.errorMessage ?? "").multilineTextAlignment(.center).padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    
                    Button {
                        
                        dataFetcher.getIdeskData(ideskAppdata: self.ideskAppData!)
                        
                    } label: {
                        Text("Retry").fontWeight(.bold).foregroundColor(.black)
                    }.padding().background(Color(hex: AppConstants.gray)).clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous ))
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center).background(Color(hex: UInt(AppConstants.white)))
            }else {
                WebViewTS(ideskAppData: dataFetcher.ideskChatDataRes?.data ?? "")
            }
            
            
        }.onAppear{
            dataFetcher.getIdeskData(ideskAppdata: ideskAppData!)
        }
        
    }
}

//struct iDeskChatUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        iDeskChatUIView()
//    }
//}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
}
