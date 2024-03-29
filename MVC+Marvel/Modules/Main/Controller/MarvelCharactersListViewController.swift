//
//  MarvelCharactersListViewController.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import UIKit

class MarvelCharactersListViewController: CommonViewController {
    //******************************************************
    //MARK: - IBOutlet Properties
    //******************************************************
    /// 캐릭터 리스트 테이블 뷰
    @IBOutlet private weak var tableMarvelCharacters: UITableView? {
        didSet {
            tableMarvelCharacters?.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        }
    }
    /// 로딩 인디케이터
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView?
    /// 로딩 뷰
    @IBOutlet private weak var viewLoading: UIView?
    /// 로딩 상태 알림
    @IBOutlet private weak var lblAlertMessage: UILabel?
    
    //******************************************************
    //MARK: - Properties
    //******************************************************
    /// 테이블뷰 설정정보
    private var tableConfig = ModelCollection<Result>()
    /// 캐릭터 리스트 비즈니스 로직
    private var charactersTask: MarvelCharactersTaskInput?
    /// 이미지 비즈니스 로직
    private var imageTask: ImageTaskInput?
    /// 최대 요청 수량
    private var requestItemCount = 20
    /// 현재 페이징중인지 여부
    private var isPaging = true
    /// 다음페이지가 있는지 여부
    private var hasNextPage = true
    /// 현재 셀 확장여부 상태 저장 리스트
    private var isExpandView = [Bool]()
    /// 노출된 셀 높이저장 리스트
    private var cellHeights = [IndexPath: CGFloat]()
    /// 썸네일 URL
    private var thumbnailURLs = [String]()
    /// 네트워크 로딩상태 열거
    private var state: State = .loading {
        didSet {
            setLoadingView(state: self.state)
        }
    }
    
    //******************************************************
    //MARK: - ViewController LifeCycle
    //******************************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableViewCell()
        bindModel()
        state = .loading
        charactersTask?.requestCharactersList(type: Marvel.self, for: requestItemCount)
    }
    
    //******************************************************
    //MARK: - Instance
    //******************************************************
    /**
     * @네비게이션 바 설정
     * @creator : coder3306
     */
    private func setNavigationBar() {
        let naviItems = NavigationBarItems(title: "Marvel Characters")
        initNavigationBar(naviItems: naviItems)
    }
    
    /**
     * @모델 바인딩
     * @creator : coder3306
     */
    private func bindModel() {
        let characters = MarvelCharactersTask(networkClient: NetworkManager(), url: MarvelURL.characterList)
        characters.output = self
        self.charactersTask = characters
        
        let image = ImageProvider(imageClient: NetworkManager())
        image.output = self
        self.imageTask = image
    }
    
    /**
     * @뷰컨트롤러 데이터 상태 간 UI 설정
     * @creator : coder3306
     * @param state : 현재 데이터 수신 상태(로딩/완료/에러)
     */
    private func setLoadingView(state: State) {
        self.tableMarvelCharacters?.alpha = (state == .loading || state == .error) ? 0.0 : 1.0
        self.viewLoading?.alpha = (state == .loading || state == .error) ? 1.0 : 0.0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        self.lblAlertMessage?.text = (state == .loading) ? "로딩중 입니다." : "오류 발생"
        self.lblAlertMessage?.isHidden = (state == .loading || state == .error) ? false : true
        
        if state == .loading {
            loadingIndicator?.startAnimating()
        } else if state == .error {
            loadingIndicator?.stopAnimating()
        } else {
            loadingIndicator?.stopAnimating()
            self.isPaging = false
            setNavigationBar()
            self.tableMarvelCharacters?.reloadData()
        }
    }
    
    /**
     * @캐릭터 상세보기
     * @creator : coder3306
     * @param characters : 캐릭터 상세 데이터
     * @param info : 선택된 캐릭터의 정보
     */
    private func requestCharactersDetail(with characters: Result, info: CharactersInfo) {
        let charactersDetailViewController = MarvelCharacterDetailViewController(nibName: "MarvelCharacterDetailViewController", bundle: nil)
        var items: Comics?
        switch info {
            case .comics:
                items = characters.comics
            case .series:
                items = characters.series
            case .events:
                items = characters.events
            case .none:
                break
        }

        if let items = items, checkEmptyCharactersDetail(items.available) {
            charactersDetailViewController.items = items
            charactersDetailViewController.charactersInfo = info
            self.navigationController?.pushViewController(charactersDetailViewController, animated: true)
        }
    }
    
    /**
     * @상세보기 데이터 검사
     * @데이터 없을 경우 팝업 노출 설정
     * @creator : coder3306
     * @param available : 상세보기 아이템 갯수
     * @Return : 데이터 유무
     */
    private func checkEmptyCharactersDetail(_ available: Int) -> Bool {
        if available == 0 {
            self.emptyDataAlert()
            return false
        }
        return true
    }
    
    /**
     * @데이터가 없을 시 노출 할 알림 팝업
     * @creator : coder3306
     */
    private func emptyDataAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "알림", message: "정보가 없습니다.", preferredStyle: UIAlertController.Style.alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: false)
        }
    }
}

//MARK: - tableViewExtension
extension MarvelCharactersListViewController: tableViewExtension {
    /**
     * @테이블뷰 셀 초기화
     * @creator : coder3306
     */
    private func initTableViewCell() {
        if let tableView = tableMarvelCharacters {
            MarvelCharactersTableViewCell.registerXib(targetView: tableView)
            MarvelCharactersLoadingTableViewCell.registerXib(targetView: tableView)
        }
    }
    
    //******************************************************
    //MARK: - TableView Setting
    //******************************************************
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tableConfig.count
        } else if section == 1 && isPaging && hasNextPage {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listIdentifier = MarvelCharactersTableViewCell.reuseIdentifier
        let pageIdentifier = MarvelCharactersLoadingTableViewCell.reuseIdentifier
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: listIdentifier, for: indexPath) as? MarvelCharactersTableViewCell {
                cell.selectionStyle = .none
                guard let items = tableConfig.elements, items.isEmpty == false else { return  UITableViewCell() }
                let item = items[indexPath.row]
                let cachedImage = cache.object(forKey: item.thumbnail.thumbnailURL as NSString)
                cell.setData(item, image: cachedImage, isExpand: isExpandView[indexPath.row])
                cell.didSelectCharactersInfo { [weak self] info in
                    print("인덱스 ---------- >>>>>> \(indexPath.row) 선택된 코드 ------------ >>>>>> \(info?.code ?? 0)")
                    if let info = info {
                        self?.requestCharactersDetail(with: item, info: info)
                    }
                }
                cell.didSelectDetail { [weak self] isSelected in
                    print("확장 셀 인덱스 --------- >>> \(indexPath.row) 확장 상태 ---------- >>> \(isSelected)")
                    self?.isExpandView[indexPath.row] = isSelected
                    if let detailView = cell.detailView {
                        cell.setExpandView(detailView, isExpanded: isSelected, index: indexPath, tableView: tableView)
                    }
                }
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: pageIdentifier, for: indexPath) as? MarvelCharactersLoadingTableViewCell {
                cell.loadingStart()
                return cell
            }
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
    
    //******************************************************
    //MARK: - Paging
    //******************************************************
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.height) {
            if isPaging == false && hasNextPage {
                receivePaging()
            }
        }
    }
    
    /**
     * @페이징 요청 수신
     * @creator : coder3306
     */
    private func receivePaging() {
        self.tableMarvelCharacters?.isUserInteractionEnabled = false
        self.isPaging = true
        self.tableMarvelCharacters?.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.processPaging()
        }
    }
    
    /**
     * @페이징 요청 처리
     * @creator : coder3306
     */
    private func processPaging() {
        DispatchQueue.main.async {
            print(" \(self.requestItemCount) 아이템 갯수,  \(self.hasNextPage) 다음페이지 ")
            self.hasNextPage = self.requestItemCount >= 80 ? false : true
            self.requestItemCount += 20
            self.charactersTask?.requestCharactersList(type: Marvel.self, for: self.requestItemCount)
            self.tableMarvelCharacters?.isUserInteractionEnabled = true
        }
    }
}

//MARK: - Output
extension MarvelCharactersListViewController: MarvelCharactersTaskOutput, ImageTaskOutput {
    /**
     * @요청된 캐릭터 리스트 저장 및 UI 업데이트
     * @creator : coder3306
     * @param characters : 캐릭터 리스트
     */
    func responseCharactersList(_ characters: Marvel?) {
        if let characters {
            self.tableConfig.elements = characters.data.results
            let count = (characters.data.results.count != requestItemCount) ? (characters.data.results.count - requestItemCount) : requestItemCount
            // 셀 확장상태 초기화
            for _ in 0 ..< count {
                self.isExpandView.append(false)
            }
            // 이미지 다운로드 요청
            characters.data.results.forEach({
                thumbnailURLs.append($0.thumbnail.thumbnailURL)
                self.imageTask?.requestImage(from: $0.thumbnail.thumbnailURL)
            })
            self.state = .ready
        } else {
            self.tableConfig.elements = nil
            self.state = .error
        }
    }

    /**
     * @요청된 캐릭터 이미지 캐싱처리
     * @creator : coder3306
     * @param image : 요청된 이미지
     * @param urlString : 이미지 다운로드 주소
     */
    func responseImage(_ image: UIImage?, to urlString: String) {
        if let image {
            cache.setObject(image, forKey: urlString as NSString)
            self.updateImageCell(to: image, for: urlString)
        }
    }

    /**
     * @요청된 캐릭터 이미지 업데이트
     * @creator : coder3306
     * @param image : 다운로드된 이미지
     * @param urlString : 이미지 다운로드 주소
     */
    func updateImageCell(to image: UIImage?, for urlString: String) {
        let index = thumbnailURLs.firstIndex(of: urlString) ?? 0
        if let cell = self.tableMarvelCharacters?.cellForRow(at: IndexPath(row: index, section: 0)) as? MarvelCharactersTableViewCell {
            let width = cell.imgThumbnail?.frame.size.width ?? .zero
            let height = cell.imgThumbnail?.frame.size.height ?? .zero
            if let resizeImage = image?.resizeImage(newSize: CGSize(width: width, height: height)) {
                cell.imgThumbnail?.image = resizeImage
            } else {
                cell.imgThumbnail?.image = image
            }
        }
    }
}
