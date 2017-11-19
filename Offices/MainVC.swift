//
//  MainVC.swift
//  Offices
//
//  Created by Admin on 18.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Moya

class MainVC: UIViewController {
  
  let institutionsView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .white
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.alpha = 0
    return tableView
  }()
  
  let activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    return activityIndicatorView
  }()
  
  var institutionsArray: [Institution]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Список заведений"
    view.backgroundColor = .red
    
    institutionsView.dataSource = self
    institutionsView.register(InstitutionCell.self, forCellReuseIdentifier: InstitutionCell.reuseId)
    
    loadInstitutions()
    setAutolayout()
  }
  
  func loadInstitutions() {
    activityIndicatorView.startAnimating()
    ServerManager.shared.getInstitutions(with: {
      self.institutionsArray = $0
      self.activityIndicatorView.stopAnimating()
      UIView.animate(withDuration: 1, animations: {
        self.institutionsView.alpha = 1
      })
      self.institutionsView.reloadData()
    }) {
      self.activityIndicatorView.stopAnimating()
      let errorAlert = UIAlertController(title: "Ошибка", message: "\($0)", preferredStyle: UIAlertControllerStyle.alert)
      let retryAction = UIAlertAction(title: "Повторить", style: UIAlertActionStyle.default, handler: { action in
       self.loadInstitutions()
      })
      errorAlert.addAction(retryAction)
      self.present(errorAlert, animated: true, completion: nil)
    }
  }
}

extension MainVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return institutionsArray?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let institutionCell = tableView.dequeueReusableCell(withIdentifier: InstitutionCell.reuseId, for: indexPath) as? InstitutionCell, let institutionsArray = institutionsArray else { return UITableViewCell() }
    institutionCell.set(institution: institutionsArray[indexPath.row])
    return institutionCell
  }
}

extension MainVC: Autolayouted {
  var autolayout: [Autolayouted.Autolayout] {
    return [
      (view: institutionsView, layout: {
        $0.edges.equalToSuperview()
      }),
      (view: activityIndicatorView, layout: {
        $0.center.equalToSuperview()
      })
    ]
  }
}


class InstitutionCell: UITableViewCell, ReusableView {
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 20)
    return label
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  let ratingLabel: UILabel = {
    let label = UILabel()
    label.textColor = .red
    return label
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setAutolayout()
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func set(institution: Institution) {
    nameLabel.text = institution.name
    descriptionLabel.text = institution.shortDescription
    ratingLabel.text = "\(institution.rating)"
  }
}

extension InstitutionCell: Autolayouted {
  var autolayout: [Autolayouted.Autolayout] {
    return [
      (view: nameLabel, layout: {
        $0.top.equalToSuperview().offset(16)
        $0.left.equalToSuperview().offset(16)
        $0.right.equalToSuperview().offset(-16)
      }),
      (view: descriptionLabel, layout: {
        $0.top.equalTo(self.nameLabel.snp.bottom).offset(16)
        $0.left.greaterThanOrEqualToSuperview().offset(16)
        $0.bottom.lessThanOrEqualToSuperview().offset(-16)
      }),
      (view: ratingLabel, layout: {
        $0.top.equalTo(self.nameLabel.snp.bottom).offset(16)
        $0.left.equalTo(self.descriptionLabel.snp.right).offset(16)
        $0.right.equalToSuperview().offset(-16)
        $0.bottom.lessThanOrEqualToSuperview().offset(-16)
      })
    ]
  }
}
