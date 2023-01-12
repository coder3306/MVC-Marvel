//
//  CommonConfig.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/11.
//

import Foundation

public enum State {
    case loading
    case ready
    case error
}

public struct CommonConfig<T> {
    // 모델 매핑된 데이터
    var items: [T]?
    // 셀 섹션 갯수
    lazy var sectionCount = 1
    // 셀 아이템 갯수
    lazy var cellCount = 0
    // 데이터 유무
    lazy var isEmpty = false
    
    // 셀 섹션 갯수 설정
    var calcSectionCount: Int {
        get {
            return 1
        } set {
            sectionCount = newValue
        }
    }
    
    // 셀 Row 갯수 설정
    var calcCellCount: Int {
        get {
            return items?.count ?? 0
        } set {
            cellCount = newValue
        }
    }
    
    // 데이터 유무 검사
    var calcIsEmpty: Bool {
        get {
            return (items?.isEmpty == true || items == nil)
        } set {
            isEmpty = newValue
        }
    }
    
    /**
     * @셀 데이터 설정
     * @creator : coder3306
     * @param index : 각 셀의 IndexPath
     * @Return : Index에 맞는 데이터 반환
     */
    func cellForRowAtItems(At index: Int) -> T? {
        return items?[index] ?? nil
    }
}
