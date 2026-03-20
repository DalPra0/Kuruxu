//
//  PDFviewersheet.swift
//  Jacus&Jaguaras
//
//  Created by Carla Araujo on 20/03/26.
//

import SwiftUI
import PDFKit

struct PDFViewer: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct PDFViewerSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if let url = Bundle.main.url(forResource: "cartas", withExtension: "pdf") {
                    PDFViewer(url: url)
                        .ignoresSafeArea(edges: .bottom)
                } else {
                    ContentUnavailableView(
                        "PDF não encontrado",
                        systemImage: "doc.fill",
                        description: Text("Verifique se o arquivo foi adicionado ao bundle.")
                    )
                }
            }
            .navigationTitle("Cartas para Imprimir")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fechar") { dismiss() }
                        .foregroundColor(.secondary400)
                }
            }
        }
    }
}
