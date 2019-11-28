//
//  ImagePicker.swift
//  CoffeeMaster
//
//  Created by Mingtian Yang on 11/28/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import SwiftUI
import Combine

final class ImagePicker : ObservableObject {
  static let shared : ImagePicker = ImagePicker()
  private init() {}
  let view = ImagePicker.View()
  let coordinator = ImagePicker.Coordinator()

    let willChange = PassthroughSubject<Image?, Never>()
  @Published var image: Image? = nil {
    didSet {
      if image != nil { willChange.send(image) }
    }
  }
}

extension ImagePicker {
  class Coordinator: NSObject,
                     UINavigationControllerDelegate,
                     UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
      ImagePicker.shared.image = Image(uiImage: uiImage)
      picker.dismiss(animated:true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      picker.dismiss(animated:true)
    }
  }
}

extension ImagePicker {
  struct View: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
      ImagePicker.shared.coordinator
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker.View>) -> UIImagePickerController {
      let picker = UIImagePickerController()
      picker.delegate = context.coordinator
      return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker.View>) {}
  }
}
