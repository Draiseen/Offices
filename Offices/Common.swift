//
//  Common.swift
//  Offices
//
//  Created by Admin on 19.11.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import SnapKit


protocol ReusableView {
  static var reuseId: String { get }
}

extension ReusableView where Self: UIView {
  static var reuseId: String { return String(describing: Self.self) }
}


protocol Autolayouted {
  typealias Autolayout = (view: UIView, layout: (ConstraintMaker) -> Void)
  var autolayout: [Autolayout] { get }
}

extension Autolayouted where Self: UIViewController {
  func setAutolayout() {
    autolayout.forEach{ self.view.addSubview($0.view) }
    autolayout.forEach{ $0.view.snp.makeConstraints($0.layout) }
  }
}

extension Autolayouted where Self: UICollectionViewCell {
  func setAutolayout() {
    autolayout.forEach{ self.contentView.addSubview($0.view) }
    autolayout.forEach{ $0.view.snp.makeConstraints($0.layout) }
  }
}

extension Autolayouted where Self: UITableViewCell {
  func setAutolayout() {
    autolayout.forEach{ self.contentView.addSubview($0.view) }
    autolayout.forEach{ $0.view.snp.makeConstraints($0.layout) }
  }
}

extension Autolayouted where Self: UIView {
  func setAutolayout() {
    autolayout.forEach{ self.addSubview($0.view) }
    autolayout.forEach{ $0.view.snp.makeConstraints($0.layout) }
  }
}
