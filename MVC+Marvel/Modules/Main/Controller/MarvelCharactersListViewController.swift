//
//  MarvelCharactersListViewController.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import UIKit

class MarvelCharactersListViewController: CommonViewController {
    @IBOutlet private weak var tableMarvelCharacters: UITableView? {
        didSet {
            tableMarvelCharacters?.contentInset = UIEdgeInsets(top: 56, left: 0, bottom: 0, right: 0)
        }
    }
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView?
    @IBOutlet private weak var viewLoading: UIView?
    @IBOutlet private weak var lblAlertMessage: UILabel?
    
    private var tableConfig = CommonConfig<Marvel>()
    private var model: MarvelCharactersTaskInput?
    private var requestItemCount = 20
    private var isPaging = true
    private var hasNextPage = true
    private var isExpandView = [Bool]()
    private var cellHeights = [IndexPath: CGFloat]()
    private var state: State = .loading {
        didSet {
            setLoadingView(state: self.state)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableViewCell()
        bindModel()
        state = .loading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model?.requestCharactersList(for: requestItemCount)
    }
    
    private func setNavigationBar() {
        let naviItems = NavigationBarItems(title: "Marvel Characters")
        initNavigationBar(naviItems: naviItems)
    }
    
    /**
     * @모델 바인딩
     * @creator : coder3306
     */
    private func bindModel() {
        let model = MarvelCharactersTask()
        model.output = self
        self.model = model
    }
    
    /**
     * @뷰컨트롤러 데이터 상태 간 UI 설정
     * @creator : coder3306
     * @param state : 현재 데이터 수신 상태(로딩/완료/에러)
     */
    private func setLoadingView(state: State) {
        UIView.animate(withDuration: 0.3) {
            self.tableMarvelCharacters?.alpha = (state == .loading || state == .error) ? 0.0 : 1.0
            self.viewLoading?.alpha = (state == .loading || state == .error) ? 1.0 : 0.0
        }
        self.lblAlertMessage?.text = (state == .loading) ? "로딩중 입니다." : "오류 발생"
        self.lblAlertMessage?.isHidden = (state == .loading || state == .error) ? false : true
        
        if state == .loading {
            loadingIndicator?.startAnimating()
        } else if state == .error {
            loadingIndicator?.stopAnimating()
        } else {
            loadingIndicator?.stopAnimating()
            self.tableConfig.cellCount = self.tableConfig.items?.first?.data.results.count ?? 0
            self.tableConfig.calcSectionCount = 2
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
        var available: Bool?
        switch info {
            case .comics:
                available = checkEmptyCharactersDetail(characters.comics.available)
                charactersDetailViewController.items = characters.comics
            case .series:
                available = checkEmptyCharactersDetail(characters.series.available)
                charactersDetailViewController.items = characters.series
            case .events:
                available = checkEmptyCharactersDetail(characters.events.available)
                charactersDetailViewController.items = characters.events
            case .none:
                break
        }
        if available ?? false {
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
    private func initTableViewCell() {
        if let tableView = tableMarvelCharacters {
            MarvelCharactersTableViewCell.registerXib(targetView: tableView)
            MarvelCharactersLoadingTableViewCell.registerXib(targetView: tableView)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tableConfig.cellCount
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
                if let item = tableConfig.items?.first?.data.results[indexPath.row] {
                    cell.setData(item, with: cache)
                    cell.detailView?.isHidden = isExpandView[indexPath.row]
                    cell.didSelectCharactersInfo { [weak self] info in
                        print("인덱스 ---------- >>>>>> \(indexPath.row) 선택된 코드 ------------ >>>>>> \(info?.code ?? 0)")
                        if let selectedItem = self?.tableConfig.items?.first?.data.results[indexPath.row], let info {
                            self?.requestCharactersDetail(with: selectedItem, info: info)
                        }
                    }
                    cell.didSelectDetail { [weak self] isSelected in
                        //FIXME: - 셀 확장 시 버튼 클릭하면 인덱스 오류 발생
                        print("확장 셀 인덱스 --------- >>> \(indexPath.row) 확장 상태 ---------- >>> \(isSelected)")
                        self?.tableMarvelCharacters?.performBatchUpdates({
                            self?.isExpandView[indexPath.row] = !isSelected
                            cell.detailView?.isHidden = !isSelected
                            UIView.animate(withDuration: 0.3) {
                                cell.detailView?.alpha = isSelected ? 1 : 0
                                self?.tableMarvelCharacters?.layoutIfNeeded()
                            }
                        })
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
        if scrollView.contentOffset.y > (self.navigationController?.navigationBar.frame.size.height ?? 0.0) {
            self.navigationController?.navigationItem.title = "Marvel Character"
        }
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
            self.model?.requestCharactersList(for: self.requestItemCount)
            self.tableMarvelCharacters?.isUserInteractionEnabled = true
        }
    }
}

//MARK: - Output
extension MarvelCharactersListViewController: MarvelCharactersTaskOutput {
    /**
     * @요청된 캐릭터 리스트 저장 및 UI 업데이트
     * @creator : coder3306
     * @param characters : 캐릭터 리스트
     */
    func responseCharactersList(with characters: Marvel?) {
        if let characters {
            self.tableConfig.items = [characters]
            let count = (characters.data.results.count != requestItemCount) ? (characters.data.results.count - requestItemCount) : requestItemCount
            for _ in 0 ..< count {
                self.isExpandView.append(true)
            }
            self.state = .ready
        } else {
            self.tableConfig.items = nil
            self.state = .error
        }
    }
}
