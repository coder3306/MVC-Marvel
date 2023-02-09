//
//  ImageProvider.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/02/09.
//

import UIKit

protocol ImageTaskInput {
    /**
     * @이미지 데이터 요청
     * @creator : coder3306
     */
    func requestImage(from urlString: String)
}

protocol ImageTaskOutput: AnyObject {
    /**
     * @이미지 응답 데이터
     * @creator : coder3306
     * @param image : 다운로드된 이미지 데이터
     */
    func responseImage(_ image: UIImage?, to urlString: String)
}

final class ImageProvider: ImageTaskInput {
    /// 이미지 설정
    private let imageClient: ImageClient
    /// 응답 데이터 델리게이트 프로토콜
    weak var output: ImageTaskOutput?
    
    /**
     * @비즈니스 로직 초기화
     * @creator : coder3306
     * @param imageClinet : 이미지 설정
     */
    init(imageClient: ImageClient) {
        self.imageClient = imageClient
    }
    
    /**
     * @이미지 데이터 요청
     * @creator : coder3306
     */
    func requestImage(from urlString: String) {
        DispatchQueue.global(qos: .background).async {
            self.imageClient.downloadImage(from: urlString) { [weak self] image in
                self?.output?.responseImage(image, to: urlString)
            }
        }
    }
}
