import CoreML
import Vision
import UIKit

class MLModelHandler {
    static let shared = MLModelHandler()
    private let wikipediaAPIBaseURL = "https://en.wikipedia.org/api/rest_v1/page/summary/"

    private init() {}

    // 객체 감지
    func analyzeImage(_ image: UIImage, completion: @escaping (String) -> Void) {
        guard let model = try? VNCoreMLModel(for: YOLOv3FP16().model) else {
            completion("모델 로드 실패")
            return
        }

        let request = VNCoreMLRequest(model: model) { request, _ in
            if let results = request.results as? [VNRecognizedObjectObservation],
               let firstResult = results.first {
                let label = firstResult.labels.first?.identifier ?? "Unknown"
                let confidence = firstResult.labels.first?.confidence ?? 0.0
                let confidenceText = String(format: "%.2f", confidence * 100)
                let resultText = "감지된 객체: \(label), 신뢰도: \(confidenceText)%"

                // Wikipedia API 호출
                self.fetchWikipediaInfo(for: label) { wikiInfo in
                    completion("\(resultText)\n\n\(wikiInfo)")
                }
            } else {
                completion("객체를 감지하지 못했습니다.")
            }
        }

        guard let ciImage = CIImage(image: image) else {
            completion("이미지 변환 실패")
            return
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up)
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
            } catch {
                completion("처리 오류: \(error.localizedDescription)")
            }
        }
    }

    // Wikipedia API 호출
    private func fetchWikipediaInfo(for objectName: String, completion: @escaping (String) -> Void) {
        let query = objectName.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? objectName
        let urlString = "\(wikipediaAPIBaseURL)\(query)"

        guard let url = URL(string: urlString) else {
            completion("잘못된 Wikipedia URL입니다.")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion("Wikipedia API 호출 오류: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        let title = json["title"] as? String ?? "제목 없음"
                        let description = json["description"] as? String ?? "설명 없음"
                        let extract = json["extract"] as? String ?? "추가 설명을 찾을 수 없습니다."

                        let result = """
                        Wikipedia 정보:
                        제목: \(title)
                        설명: \(description)
                        요약: \(extract)
                        """
                        completion(result)
                    } else {
                        completion("Wikipedia 정보를 찾을 수 없습니다.")
                    }
                } catch {
                    completion("데이터 처리 오류: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}

