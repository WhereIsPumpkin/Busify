////
////  CardScanManager.swift
////  iNet
////
////  Created by Saba Gogrichiani on 02.02.24.
////
//
//// CardScanManager.swift
//import SwiftUI
//import Vision
//import VisionKit
//
//// Placeholder for a function that integrates VNDocumentCameraViewController and processes images
//struct CardScanManager: UIViewControllerRepresentable {
//    @Environment(\.presentationMode) var presentationMode
//    var onCardDetailsScanned: (CardDetails) -> Void
//
//    func makeUIViewController(context: Context) -> VNDocumentCameraViewController {
//        let documentCameraViewController = VNDocumentCameraViewController()
//        documentCameraViewController.delegate = context.coordinator
//        return documentCameraViewController
//    }
//
//    func updateUIViewController(_ uiViewController: VNDocumentCameraViewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, VNDocumentCameraViewControllerDelegate {
//        var parent: CardScanManager
//
//        init(_ parent: CardScanManager) {
//            self.parent = parent
//        }
//
//        func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//            guard scan.pageCount > 0 else {
//                controller.dismiss(animated: true)
//                return
//            }
//            // Process the first scanned page
//            let image = scan.imageOfPage(at: 0)
//            processImage(image)
//        }
//
//        func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
//            controller.dismiss(animated: true)
//        }
//
//        private func processImage(_ image: UIImage) {
//            // Use Vision to process the UIImage here
//            guard let cgImage = image.cgImage else { return }
//
//            let request = VNRecognizeTextRequest(completionHandler: { (request, error) in
//                guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
//
//                let cardDetails = self.parseObservations(observations)
//                DispatchQueue.main.async {
//                    self.parent.onCardDetailsScanned(cardDetails)
//                    self.parent.presentationMode.wrappedValue.dismiss()
//                }
//            })
//
//            request.recognitionLevel = .accurate
//            let requests = [request]
//            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//            DispatchQueue.global(qos: .userInitiated).async {
//                do {
//                    try handler.perform(requests)
//                } catch {
//                    print(error)
//                }
//            }
//        }
//
//        private func parseObservations(_ observations: [VNRecognizedTextObservation]) -> CardDetails {
//            // Implement parsing logic based on observations
//            // This is simplified and needs to be adapted to your card format
//            let cardDetails = CardDetails(number: nil, name: nil, expiryDate: nil)
//            return cardDetails
//        }
//    }
//}
