// SPDX-License-Identifier: GPL-3.0-or-later

/**
 * Shows the user an information view.
 */

import UIKit

final class ToolTipView: UIView, ToolTipViewUpdatable {
  var didUpdatePage: ((ConjViewShiftButtonsState) -> Void)?

  // MARK: Private propeties

  private var currentIndex: Int = 0 {
    didSet {
      if currentIndex == datasources.count - 1 {
        didUpdatePage?(.rightInactive)
      } else if currentIndex == 0 {
        didUpdatePage?(.leftInactive)
      } else {
        didUpdatePage?(.bothActive)
      }
    }
  }

  private var datasources: [ToolTipViewDatasourceable]

  // MARK: Private UI

  private(set) lazy var contentLabel: UILabel = {
    let tempLabel = UILabel()
    let datasource = getCurrentDatasource()

    if let textColor = datasource.theme.textColor {
      tempLabel.textColor = textColor
    }

    if let font = datasource.theme.textFont {
      tempLabel.font = font
    }

    if let textAlignment = datasource.theme.textAlignment {
      tempLabel.textAlignment = textAlignment
    }

    tempLabel.attributedText = datasource.getCurrentText()
    tempLabel.numberOfLines = 0

    return tempLabel
  }()

  private(set) var pageControl = UIPageControl()

  // MARK: Init

  init(datasources: [ToolTipViewDatasourceable]) {
    self.datasources = datasources
    pageControl.currentPage = 0
    pageControl.numberOfPages = datasources.count
    super.init(frame: CGRect.zero)

    let datasource = getCurrentDatasource()
    pageControl.pageIndicatorTintColor = datasource.theme.textColor?.withAlphaComponent(0.3)
    pageControl.currentPageIndicatorTintColor = datasource.theme.textColor
    buildHierarchy()
    setupConstraints()
    configureViews()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Overrides

  override func layoutSubviews() {
    let datasource = getCurrentDatasource()

    if let cornerRadius = datasource.theme.cornerRadius {
      layer.cornerRadius = cornerRadius
    }

    if let maskedCorners = datasource.theme.maskedCorners {
      layer.maskedCorners = maskedCorners
    }

    if let masksToBounds = datasource.theme.masksToBounds {
      layer.masksToBounds = masksToBounds
    }
  }

  // MARK: Methods

  func updateNext() {
    let tempCurrentIndex = currentIndex + 1
    updateText(index: tempCurrentIndex)
    pageControl.currentPage += 1
  }

  func updatePrevious() {
    let tempCurrentIndex = max(0, currentIndex - 1)
    updateText(index: tempCurrentIndex)
    pageControl.currentPage -= 1
  }

  func updateText(index: Int) {
    if index > datasources.count - 1 {
      return
    }
    currentIndex = index
    let newDatasource = datasources[index]
    animateDatasourceChange(newDatasource: newDatasource)
  }

  // MARK: Private methods

  private func getCurrentDatasource() -> ToolTipViewDatasourceable {
    datasources[currentIndex]
  }

  private func animateDatasourceChange(newDatasource: ToolTipViewDatasourceable) {
    UIView.transition(with: contentLabel,
                      duration: 0.25,
                      options: .showHideTransitionViews,
                      animations: { [weak self] in
                        self?.contentLabel.attributedText = newDatasource.getCurrentText()
                        self?.backgroundColor = newDatasource.theme.backgroundColor
                      }, completion: nil)
  }
}

extension ToolTipView {
  func buildHierarchy() {
    addSubview(contentLabel)
    addSubview(pageControl)
  }

  func setupConstraints() {
    contentLabel.translatesAutoresizingMaskIntoConstraints = false
    contentLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
    contentLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
    contentLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true

    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 5).isActive = true
    pageControl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -5).isActive = true
    pageControl.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5).isActive = true
    pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    pageControl.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
  }

  func configureViews() {
    let datasource = getCurrentDatasource()
    backgroundColor = datasource.theme.backgroundColor
  }
}
