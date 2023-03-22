//
//  AddNewExpense.swift
//  CoreDateToJSON
//
//  Created by Aleksey Alyonin on 22.03.2023.
//

import SwiftUI

struct AddNewExpense: View {
    
    @State private var title: String = ""
    @State private var dateOfPurchase: Date = .init()
    @State private var amountSpent: Double = 0
    //    Environment Properties
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    
    var body: some View {
        NavigationStack {
            List {
                Section("Purchase Item") {
                    TextField("", text: $title)
                }
                Section("Date of Purchase") {
                    DatePicker("", selection: $dateOfPurchase, displayedComponents: [.date])
                        .labelsHidden()
                }
                Section("Amount Stant") {
                    TextField(value: $amountSpent, formatter: currencyFormatter) {
                    }
                    .labelsHidden()
                    .keyboardType(.numberPad)
                }
                .navigationTitle("New Expanse")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add", action: addExpense)
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
            }
        }
    }
        //Adding new expense to core data
        func addExpense(){
            do {
                let purchase = Purchase(context: context)
                purchase.id = .init()
                purchase.title = title
                purchase.dataOfPurchase = dateOfPurchase
                purchase.amountSpent = amountSpent
                
                try context.save()
                //            Dismissing after successful additing
                dismiss()
            } catch {
                //            DO Action
                print(error.localizedDescription)
            }
        }
    }


struct AddNewExpense_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// NumberFormatter
 let currencyFormatter: NumberFormatter = {
                        let formatter = NumberFormatter()
                        formatter.allowsFloats = false
                        formatter.numberStyle = .currency
                        return formatter
 }()
