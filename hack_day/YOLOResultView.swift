//
//  YOLOResultView.swift
//  hack_day
//
//  Created by 岡野裕紀 on 2025-07-02.
//

import SwiftUI
import YOLO
import AVFoundation

/// YOLOの検出結果を受け取るためのラッパーView
struct YOLOResultView: View {
    @Binding var result: YOLOResult?

    let modelPathOrName: String
    let task: YOLOTask
    let cameraPosition: AVCaptureDevice.Position

    var body: some View {
        YOLOResultViewRepresentable(
            result: $result,
            modelPathOrName: self.modelPathOrName,
            task: self.task,
            cameraPosition: self.cameraPosition
        )
    }
}

fileprivate struct YOLOResultViewRepresentable: UIViewRepresentable {
    @Binding var result: YOLOResult?

    let modelPathOrName: String
    let task: YOLOTask
    let cameraPosition: AVCaptureDevice.Position

    func makeUIView(context: Context) -> YOLOView {
        return YOLOView(frame: .zero, modelPathOrName: modelPathOrName, task: task)
    }

    func updateUIView(_ uiView: YOLOView, context: Context) {
        // ローカルパッケージの修正により、このコードがコンパイル可能になる
        uiView.onDetection = { yoloResult in
            DispatchQueue.main.async {
                self.result = yoloResult
            }
        }
    }
}
