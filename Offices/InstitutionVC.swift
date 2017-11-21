//
//  InstitutionVC.swift
//  Offices
//
//  Created by Admin on 20.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher

class InstitutionVC: UIViewController {
  
  let institutionsView: UITableView = {
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    tableView.backgroundColor = .white
    tableView.estimatedRowHeight = 200
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedSectionHeaderHeight = 500
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension
    return tableView
  }()
  
  var institution: Institution?
  var headerView: HeaderView?
  
  convenience init(with institution: Institution) {
    self.init()
    self.institution = institution
    headerView = HeaderView(with: institution)
    
    title = institution.shortDescription
    
    institutionsView.delegate = self
    institutionsView.dataSource = self
    institutionsView.register(AddressCell.self, forCellReuseIdentifier: AddressCell.reuseId)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setAutolayout()
  }
}

extension InstitutionVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return institution?.addresses.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let addressCell = tableView.dequeueReusableCell(withIdentifier: AddressCell.reuseId, for: indexPath) as? AddressCell, let addresses = institution?.addresses else { return UITableViewCell() }
    addressCell.set(address: addresses[indexPath.row])
    return addressCell
  }
}

extension InstitutionVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return headerView
  }
}

extension InstitutionVC: Autolayouted {
  var autolayout: [Autolayouted.Autolayout] {
    return [
      (view: institutionsView, layout: {
        $0.edges.equalToSuperview()
      })
    ]
  }
}


class HeaderView: UIView {
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.layer.cornerRadius = 50
    imageView.clipsToBounds = true
    return imageView
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 20)
    return label
  }()
  
  let ratingLabel: UILabel = {
    let label = UILabel()
    label.textColor = .red
    return label
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  convenience init(with institution: Institution) {
    self.init()
    nameLabel.text = institution.name
    ratingLabel.text = "Рейтинг: \(institution.rating)"
    descriptionLabel.text = institution.longDescription
    imageView.kf.setImage(with: URL(string: institution.imageHref), placeholder: #imageLiteral(resourceName: "placeholder"))
    
    setAutolayout()
  }
}

extension HeaderView: Autolayouted {
  var autolayout: [Autolayouted.Autolayout] {
    return [
      (view: imageView, layout: {
        $0.top.equalToSuperview().offset(16)
        $0.left.equalToSuperview().offset(16)
        $0.size.equalTo(CGSize(width: 100, height: 100))
      }),
      (view: nameLabel, layout: {
        $0.top.equalToSuperview().offset(16)
        $0.left.equalTo(self.imageView.snp.right).offset(16)
        $0.right.equalToSuperview().offset(-16)
      }),
      (view: ratingLabel, layout: {
        $0.top.equalTo(self.nameLabel.snp.bottom).offset(16)
        $0.left.equalTo(self.imageView.snp.right).offset(16)
        $0.right.equalToSuperview().offset(-16)
      }),
      (view: descriptionLabel, layout: {
        $0.top.equalTo(self.imageView.snp.bottom).offset(26)
        $0.left.equalToSuperview().offset(16)
        $0.right.equalToSuperview().offset(-16)
        $0.bottom.equalToSuperview().offset(-16)
      })
    ]
  }
}


class AddressCell: UITableViewCell, ReusableView {
  
  let addressLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 20)
    return label
  }()
  
  let scheduleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  
  lazy var showMapButton: UIButton = {
    let button = UIButton()
    button.setTitle("  Показать на карте  ", for: .normal)
    button.backgroundColor = .red
    button.layer.cornerRadius = 25
    button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    return button
  }()
  
  var address: Address?
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    setAutolayout()
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  func set(address: Address) {
    addressLabel.text = address.address
    scheduleLabel.text = address.schedule
    self.address = address
  }
  
  @objc func tapButton() {
    guard let address = address else { return }
    let coordinate = CLLocationCoordinate2DMake(address.latitude, address.longitude)
    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
    mapItem.name = address.address
    mapItem.openInMaps()
  }
}

extension AddressCell: Autolayouted {
  var autolayout: [Autolayouted.Autolayout] {
    return [
      (view: addressLabel, layout: {
        $0.top.equalToSuperview().offset(16)
        $0.left.equalToSuperview().offset(16)
        $0.right.equalToSuperview().offset(-16)
      }),
      (view: scheduleLabel, layout: {
        $0.top.equalTo(self.addressLabel.snp.bottom).offset(16)
        $0.left.equalToSuperview().offset(16)
        $0.right.equalToSuperview().offset(-16)
      }),
      (view: showMapButton, layout: {
        $0.top.equalTo(self.scheduleLabel.snp.bottom).offset(16)
        $0.left.greaterThanOrEqualToSuperview().offset(16)
        $0.right.lessThanOrEqualToSuperview().offset(-16)
        $0.centerX.equalToSuperview()
        $0.height.equalTo(50)
        $0.bottom.lessThanOrEqualToSuperview().offset(-16)
      })
    ]
  }
}
