//
//  Home.swift
//  CoreDateToJSON
//
//  Created by Aleksey Alyonin on 20.03.2023.
//

import SwiftUI
import CoreData

struct Home: View {
//    View Properties
    @State private var addExpanse: Bool = false
//    Fetching coreData Entity
    @FetchRequest(entity: Purchase.entity(), sortDescriptors: [NSSortDescriptor(keyPath:\Purchase.dataOfPurchase, ascending: false)],
                  animation: .easeInOut(duration: 0.3)) private var purchaseItem: FetchedResults<Purchase>
    @Environment(\.managedObjectContext) private var context
//    ShareSheet Properties
    @State private var presentShareSheet: Bool = false
    @State private var shareURL: URL = URL(string: "https://apple.com")!
    @State private var presentFilePicker: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
//                Displaying Purchase Items
                ForEach(purchaseItem) { purchase in
                    HStack(spacing: 10) {
                        VStack(alignment: .leading,spacing: 6) {
                            Text(purchase.title ?? "")
                                .fontWeight(.semibold)
                            Text((purchase.dataOfPurchase ?? .init()).formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer(minLength: 0)
//                        Displaying in Currency Format
                        Text(currencyFormatter.string(from: NSNumber(value: purchase.amountSpent)) ?? "")
                    }
                }
                
            }
            .listStyle(.insetGrouped)
            .navigationTitle("My Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        addExpanse.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        Button("Import"){
                            presentFilePicker.toggle()
                        }
                        Button("Export", action: exportCoreData)
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(-90))
                    }
                }
// Exporting Core Data to JSON file
            }
            .sheet(isPresented: $addExpanse) {
                AddNewExpense()
            /// Customizing sheet
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
                    .interactiveDismissDisabled()
            }
            .sheet(isPresented: $presentShareSheet) {
                deleteTempFile()
            } content: {
                CustomShareSheet(url: $shareURL)
            }
            ///File importer (for selecting JSON file from files app)
            .fileImporter(isPresented: $presentFilePicker, allowedContentTypes: [.json]) { result in
                switch result {
                case .success(let success):
                    importJSON(success)
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
                
            }
        }
    }
    ///Importing json file and adding to core data
    func importJSON(_ url: URL){

        do {
            let jsonData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.userInfo[.context] = context
            let item = try decoder.decode([Purchase].self, from: jsonData)
            /// since it's already loaded in context, simply save the context
            try context.save()
            print("File Imported Successfully")
        } catch {
            ///Do Action
            print(error)
        }
    }
    
    func deleteTempFile(){
        do {
            try FileManager.default.removeItem(at: shareURL)
            print("Removed Temp json file")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func exportCoreData(){
        do {
///Step 1
///Fetching all Core data Items for the Entity using Swift Way
            if let entityName = Purchase.entity().name {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let items = try context.fetch(request).compactMap {
                    $0 as? Purchase
                }
                ///Step 2
                ///Converting item to json string file
                let jsonData = try JSONEncoder().encode(items)
                if let jsonString = String(data: jsonData, encoding: .utf8) {

                    ///saving into  temporary document and sharing it via shareSheet
                    if let tempURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let pathURL = tempURL.appending(component: "Export\(Date().formatted(date: .complete, time: .omitted)).json")
                        try jsonString.write(to: pathURL, atomically: true, encoding: .utf8)
                        ///saved successfully
                        shareURL = pathURL
                        presentShareSheet.toggle()
                    }
                }
            }
        } catch {
//            DO ACTION
            print(error.localizedDescription)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CustomShareSheet: UIViewControllerRepresentable {
    
    @Binding var url: URL
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
    
}
