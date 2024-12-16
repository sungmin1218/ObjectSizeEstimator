import SwiftUI

struct ContentView: View {
    @State private var resultText: String = "사물을 촬영하세요!"
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Object Size Estimator")
                .font(.title)
                .bold()
                .padding()

            // 이미지 표시
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(10)
            } else {
                Text("사진을 추가하세요.")
                    .frame(width: 300, height: 300)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(10)
            }

            // 사진 촬영 버튼
            Button(action: {
                showImagePicker.toggle()
            }) {
                Text("사진 촬영")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            // 분석 버튼
            Button(action: {
                analyzeImage()
            }) {
                Text("크기 분석")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            // 결과 표시
            ScrollView {
                Text(resultText)
                    .padding()
            }
            .frame(maxHeight: 200)
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }

    private func analyzeImage() {
        guard let image = selectedImage else {
            resultText = "이미지를 선택해주세요!"
            return
        }

        resultText = "분석 중..."
        MLModelHandler.shared.analyzeImage(image) { result in
            DispatchQueue.main.async {
                self.resultText = result
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

