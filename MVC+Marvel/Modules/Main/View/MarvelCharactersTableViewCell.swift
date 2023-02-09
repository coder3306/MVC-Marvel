//
//  MarvelCharactersTableViewCell.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import UIKit

class MarvelCharactersTableViewCell: CommonTableViewCell {
    //******************************************************
    //MARK: - IBOutlet Properties
    //******************************************************
    /// 썸네일 이미지 뷰
    @IBOutlet weak var imgThumbnail: UIImageView?
    /// 캐릭터 설명
    @IBOutlet private weak var lblDescription: UILabel?
    /// 캐릭터 이름
    @IBOutlet private weak var lblName: UILabel?
    /// 코믹스 출현 횟수
    @IBOutlet private weak var lblComicsCount: UILabel?
    /// 시리즈 출현 횟수
    @IBOutlet private weak var lblSeriesCount: UILabel?
    /// 이벤트 출현 횟수
    @IBOutlet private weak var lblEventsCount: UILabel?
    /// 상세보기 스텍뷰
    @IBOutlet weak var detailView: UIStackView?
    /// 상세보기 아이템 뷰
    @IBOutlet private var detailItemView: [UIView]?
    
    //******************************************************
    //MARK: - Properties
    //******************************************************
    // 선택된 캐릭터 데이터 전달 핸들러
    private var selectHandler: dataHandler<CharactersInfo>?
    // 상세보기 버튼 선택 핸들러
    private var actionHandler: boolHandler?
    
    //******************************************************
    //MARK: - Instance
    //******************************************************
    override func awakeFromNib() {
        super.awakeFromNib()
        detailItemView?.forEach({
            $0.layer.setBorderLayout(radius: 10)
        })
    }
    
    /**
     * @데이터 설정
     * @creator : coder3306
     * @param result : 응답 데이터
     * @param cache : 이미지 캐시
     */
    public func setData(_ result: Result, image: UIImage?) {
        self.lblName?.text = result.name
        self.lblDescription?.text = result.description
        self.lblComicsCount?.text = "\(result.comics.available) 회"
        self.lblSeriesCount?.text = "\(result.series.available) 회"
        self.lblEventsCount?.text = "\(result.events.available) 회"
        
        if let image {
            self.imgThumbnail?.image = image
        }
    }
    
    /**
     * @캐릭터 상세 정보 반환 콜백 메서드
     * @creator : coder3306
     * @Return : 선택된 데이터를 콜백으로 전달
     */
    public func didSelectCharactersInfo(_ complete: @escaping dataHandler<CharactersInfo>) {
        self.selectHandler = complete
    }
    
    /**
     * @캐릭터 상세보기 선택 상태 핸들러
     * @creator : coder3306
     * @Return : 선택된 데이터를 콜백으로 전달
     */
    public func didSelectDetail(_ complete: @escaping boolHandler) {
        self.actionHandler = complete
    }
}

//MARK: - Action
extension MarvelCharactersTableViewCell {
    /**
     * @캐릭터 상세보기 선택
     * @creator : coder3306
     * @param sender : UIButton
     */
    @IBAction private func actionSelectCharactersInfo(_ sender: UIButton) {
        self.selectHandler?(CharactersInfo(index: sender.tag))
    }
    
    /**
     * @캐릭터 상세정보 선택
     * @creator : coder3306
     * @param sender : UIButton
     */
    @IBAction private func actionShowDetail(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.actionHandler?(sender.isSelected)
    }
}
