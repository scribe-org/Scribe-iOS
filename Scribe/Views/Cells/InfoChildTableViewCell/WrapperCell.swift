// SPDX-License-Identifier: GPL-3.0-or-later

import UIKit

protocol RoundableCell {
  func applyCornerRadius(corners: CACornerMask, radius: CGFloat)
  func removeCornerRadius()
}
/// Generic wrapper cell that can wrap any UITableViewCell with padding and corner radius support.
class WrapperCell: UITableViewCell {
  static let reuseIdentifier = "WrapperCell"

  private let containerView = UIView()
  private(set) var wrappedCell: UITableViewCell?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    selectionStyle = .none

    containerView.translatesAutoresizingMaskIntoConstraints = false
    containerView.backgroundColor = lightWhiteDarkBlackColor
    contentView.addSubview(containerView)

    NSLayoutConstraint.activate([
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }

  /// Configure with any cell loaded from XIB.
  func configure(withCellNamed nibName: String, section: Section) {
    wrappedCell?.removeFromSuperview()

    guard let cell = Bundle.main.loadNibNamed(
      nibName,
      owner: nil,
      options: nil
    )?.first as? UITableViewCell else {
      fatalError("Failed to load \(nibName) from XIB")
    }

    if let infoCell = cell as? InfoChildTableViewCell {
      infoCell.configureCell(for: section)
    } else if let aboutCell = cell as? AboutTableViewCell {
      aboutCell.configureCell(for: section)
    }

    cell.backgroundColor = .clear
    cell.translatesAutoresizingMaskIntoConstraints = false

    containerView.addSubview(cell)

    NSLayoutConstraint.activate([
      cell.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      cell.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      cell.topAnchor.constraint(equalTo: containerView.topAnchor),
      cell.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
    ])

    wrappedCell = cell
  }

  func applyCornerRadius(corners: CACornerMask, radius: CGFloat) {
    containerView.layer.maskedCorners = corners
    containerView.layer.cornerRadius = radius
    containerView.layer.masksToBounds = true
  }

  func removeCornerRadius() {
    containerView.layer.cornerRadius = 0
    containerView.layer.masksToBounds = false
  }

  // MARK: Static Helper

  /// Apply corner radius to a cell based on its position in the section.
  static func applyCornerRadius(
    to cell: UITableViewCell,
    isFirst: Bool,
    isLast: Bool,
    radius: CGFloat = 12
  ) {
    guard let roundableCell = cell as? RoundableCell else { return }

    if isFirst && isLast {
      roundableCell.applyCornerRadius(
        corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner],
        radius: radius
      )
    } else if isFirst {
      roundableCell.applyCornerRadius(
        corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner],
        radius: radius
      )
    } else if isLast {
      roundableCell.applyCornerRadius(
        corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner],
        radius: radius
      )
    } else {
      roundableCell.removeCornerRadius()
    }
  }
}

extension WrapperCell: RoundableCell {}
