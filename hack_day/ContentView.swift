//
//  ContentView.swift
//  hack_day
//
//  Created by 山路和希 on 2025/06/30.
//

import SwiftUI
import YOLO

struct ContentView: View {
    var body: some View {
        YOLOCamera(modelPathOrName:"m_best",
                   task: .detect,
                   cameraPosition: .back)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// import SwiftUI
// import AVFoundation

// // API通信用の構造体を定義
// struct Detection: Codable {
//     let bbox: [Double]  // バウンディングボックス座標
//     let confidence: Double  // 信頼度スコア
//     let class_id: Int  // クラスID
//     let class_name: String  // クラス名
// }

// struct APIResponse: Codable {
//     let detections: [Detection]  // 検出結果の配列
// }

// // API通信を管理するクラス
// class APIManager: ObservableObject {
//     private let serverURL = "http://your-server-ip:8000"  // サーバーのURL（適切なIPアドレスに変更）

//     @Published var detections: [Detection] = []  // 検出結果を保存するプロパティ
//     @Published var isLoading = false  // ローディング状態を管理

//     func sendImage(_ image: UIImage) {
//         isLoading = true  // ローディング開始

//         guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//             isLoading = false  // 画像変換失敗時はローディング終了
//             return
//         }

//         var request = URLRequest(url: URL(string: "\(serverURL)/predict")!)  // API リクエストの作成
//         request.httpMethod = "POST"  // POSTメソッドに設定

//         let boundary = UUID().uuidString  // マルチパートフォームデータの境界線を生成
//         request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")  // ヘッダーを設定

//         var body = Data()  // リクエストボディを作成
//         body.append("--\(boundary)\r\n".data(using: .utf8)!)  // 境界線を追加
//         body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)  // ファイル情報を追加
//         body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)  // コンテンツタイプを設定
//         body.append(imageData)  // 画像データを追加
//         body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)  // 終了境界線を追加

//         request.httpBody = body  // ボディをリクエストに設定

//         URLSession.shared.dataTask(with: request) { data, response, error in
//             DispatchQueue.main.async {
//                 self.isLoading = false  // ローディング終了

//                 if let error = error {
//                     print("API Error: \(error)")  // エラーログを出力
//                     return
//                 }

//                 guard let data = data else {
//                     print("No data received")  // データ受信失敗のログ
//                     return
//                 }

//                 do {
//                     let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)  // JSON レスポンスをデコード
//                     self.detections = apiResponse.detections  // 検出結果を更新
//                 } catch {
//                     print("Decoding error: \(error)")  // デコードエラーのログ
//                 }
//             }
//         }.resume()  // ネットワークタスクを開始
//     }
// }

// struct ContentView: View {
//     @StateObject private var apiManager = APIManager()  // API管理オブジェクトを初期化
//     @State private var image: UIImage?  // 選択された画像を保存
//     @State private var showingImagePicker = false  // 画像選択画面の表示状態

//     var body: some View {
//         VStack {
//             if let image = image {
//                 Image(uiImage: image)  // 選択された画像を表示
//                     .resizable()
//                     .scaledToFit()
//                     .frame(maxHeight: 300)  // 最大高さを制限
//             }

//             Button("Select Image") {  // 画像選択ボタン
//                 showingImagePicker = true  // 画像選択画面を表示
//             }
//             .sheet(isPresented: $showingImagePicker) {
//                 ImagePicker(image: $image) { selectedImage in
//                     apiManager.sendImage(selectedImage)  // 選択された画像をAPIに送信
//                 }
//             }

//             if apiManager.isLoading {  // ローディング中の表示
//                 ProgressView("Processing...")  // プログレスビューを表示
//             }

//             List(apiManager.detections, id: \.class_id) { detection in  // 検出結果をリスト表示
//                 VStack(alignment: .leading) {
//                     Text("Class: \(detection.class_name)")  // クラス名を表示
//                     Text("Confidence: \(String(format: "%.2f", detection.confidence))")  // 信頼度を表示
//                 }
//             }
//         }
//         .padding()  // 余白を追加
//     }
// }

// // 画像選択用のUIImagePickerController
// struct ImagePicker: UIViewControllerRepresentable {
//     @Binding var image: UIImage?  // 選択された画像をバインド
//     let onImageSelected: (UIImage) -> Void  // 画像選択時のコールバック

//     func makeUIViewController(context: Context) -> UIImagePickerController {
//         let picker = UIImagePickerController()  // イメージピッカーを初期化
//         picker.delegate = context.coordinator  // デリゲートを設定
//         picker.sourceType = .photoLibrary  // フォトライブラリから選択
//         return picker
//     }

//     func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

//     func makeCoordinator() -> Coordinator {
//         Coordinator(self)  // コーディネーターを作成
//     }

//     class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//         let parent: ImagePicker

//         init(_ parent: ImagePicker) {
//             self.parent = parent  // 親のImagePickerを保存
//         }

//         func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//             if let uiImage = info[.originalImage] as? UIImage {
//                 parent.image = uiImage  // 選択された画像を保存
//                 parent.onImageSelected(uiImage)  // コールバックを実行
//             }
//             picker.dismiss(animated: true)  // ピッカーを閉じる
//         }
//     }
// }
