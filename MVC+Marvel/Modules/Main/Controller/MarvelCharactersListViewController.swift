//
//  MarvelCharactersListViewController.swift
//  MVC+Marvel
//
//  Created by coder3306 on 2023/01/10.
//

import UIKit

class MarvelCharactersListViewController: CommonViewController {
    @IBOutlet private weak var tableMarvelCharacters: UITableView?
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView?
    @IBOutlet private weak var viewLoading: UIView?
    @IBOutlet private weak var lblAlertMessage: UILabel?
    
    private var tableConfig = CommonConfig<Characters>()
    private var model: MarvelCharactersTaskInput?
    private var cache = NSCache<NSString, UIImage>()
    private var requestItemCount = 20
    private var isPaging = true
    private var hasNextPage = true
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
        model?.requestCharactersList(for: requestItemCount, complete: {
            print("asdf")
        })
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
            self.tableMarvelCharacters?.reloadData()
        }
    }
    
    /**
     * @페이징 요청 수신
     * @creator : coder3306
     */
    private func receivePaging() {
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
//            self.model?.requestCharactersList(for: self.requestItemCount)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            return
        }
        
//        let item = self.tableConfig.items?.first?.data.results[indexPath.row]
        print(self.tableConfig.items?.first?.data.results[indexPath.row])
    }
}

//MARK: - Output
extension MarvelCharactersListViewController: MarvelCharactersTaskOutput {
    /**
     * @요청된 캐릭터 리스트 저장 및 UI 업데이트
     * @creator : coder3306
     * @param characters : 캐릭터 리스트
     */
    func responseCharactersList(with characters: Characters?) {
        if let characters {
            self.tableConfig.items = [characters]
            self.state = .ready
        } else {
            self.tableConfig.items = nil
            self.state = .error
        }
    }
}
