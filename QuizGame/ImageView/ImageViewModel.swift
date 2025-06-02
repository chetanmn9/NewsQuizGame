//
//  ImageViewModel.swift
//  QuizGame


import SwiftUI

enum ImageState {
    case idle
    case loading
    case success(UIImage)
    case failure
    case unknown
}

class ImageViewModel: ObservableObject {
    
    @Published var state: ImageState = .idle
    

    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func loadImage() {
        // Prevent reloading if already loaded
        if case .success = state {
            return
        }
        
        state = .loading
        
        Task {
            do {
                let imageDownloaded = try await downloadImage(from: url)
                await MainActor.run {
                    self.state = .success(imageDownloaded)
                }
            } catch {
                print("Error loading image: \(error)")
                await MainActor.run {
                    self.state = .failure
                }
            }
        }
    }
    
    private func downloadImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let image = UIImage(data: data) {
            return image
        } else {
            throw URLError(.cannotDecodeContentData)
        }
    }
}

