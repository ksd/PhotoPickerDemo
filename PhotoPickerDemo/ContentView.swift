//
//  ContentView.swift
//  PhotoPickerDemo
//
//  Created by ksd on 02/04/2024.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [Image] = []
    //@State private var selectedImageData: Data?
    
    /*
    var profileImage: Image {
        guard let data = selectedImageData, let image = UIImage(data: data) else {
            return Image(systemName: "person.circle")
        }
        return Image(uiImage: image)
    }
    */
    var body: some View {
        VStack {
            
            // vis de tre billeder
            LazyHStack {
                ForEach(0..<selectedImages.count, id: \.self) { index in
                    selectedImages[index]
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                }
            }
            
            /*
            profileImage
                .resizable()
                .frame(width: 150, height: 150)
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            */
            PhotosPicker(
                selection: $selectedItems,
                maxSelectionCount: 3,
                selectionBehavior: .continuousAndOrdered,
                matching: .images,
                photoLibrary: .shared()) {
                    Label("vælg billede", systemImage: "photo")
                }
                
                .onChange(of: selectedItems) {oldValues, newValues in
                    selectedImages.removeAll()
                    newValues.forEach { item in
                        Task{
                            if let image = try? await item.loadTransferable(type: Image.self) {
                                selectedImages.append(image)
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
