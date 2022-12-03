//
//  ToolTipView.swift
//  Scribe
//
//  Created by Gabriel Moraes on 26/11/22.
//

import UIKit

enum InformationToolTipData {
  
  static let wikiDataExplanation = "Wikidata is a collaboratively edited knowledge graph that's maintained by the Wikimedia Foundation. It serves as a source of open data for projects like Wikipedia."
  
  static let wikiDataContationOrigin = "Scribe uses Wikidata's language data for many of its core features. We get information like noun genders, verb conjugations and much more!"
  
  static let howToContribute = "You can make an account at wikidata.org to join the community that's supporting Scribe and so many other projects. Help us bring free information to the world!"
  
  static func getContent() -> [String] {
    [
      InformationToolTipData.wikiDataExplanation,
      InformationToolTipData.wikiDataContationOrigin,
      InformationToolTipData.howToContribute
    ]
  }

}

protocol ViewThemeable {
  var backgroundColor: UIColor { get set }
  var textFont: UIFont? { get set }
  var textColor: UIColor? { get set }
  var textAlignment: NSTextAlignment? { get set }
  var cornerRadius: CGFloat? { get set }
  var masksToBounds: Bool? { get set }
  var maskedCorners: CACornerMask? { get set }
}

protocol ToolTipViewUpdatable {
//  var didUpdateText: ( (NSMutableAttributedString) -> Void)? { get set}

  func updateNext()
  func updatePrevious()
  func updateText(index: Int)
}

protocol ToolTipViewDatasourceable {
  var theme: ViewThemeable { get set }
  
  func getCurrentText() -> NSMutableAttributedString
}

struct ToolTipViewDatasource: ToolTipViewDatasourceable {

  var theme: ViewThemeable
  private var content: NSMutableAttributedString
  
  // MARK: - Init
  
  init(content: NSMutableAttributedString, theme: ViewThemeable) {
    self.content = content
    self.theme = theme
  }

  func getCurrentText() -> NSMutableAttributedString {
    content
  }

}

struct ToolTipViewTheme: ViewThemeable {
  var backgroundColor: UIColor
  var textFont: UIFont?
  var textColor: UIColor?
  var textAlignment: NSTextAlignment?
  var cornerRadius: CGFloat?
  var masksToBounds: Bool?
  var maskedCorners: CACornerMask?
}

final class ToolTipView: UIView, ToolTipViewUpdatable {

  // MARK: - Private propeties
    
  private var currentIndex: Int = 0
  private var datasources: [ToolTipViewDatasourceable]
  
  // MARK: - Private UI
  
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
  
  
  // MARK: - Init
  
  init(datasources: [ToolTipViewDatasourceable]){
    self.datasources = datasources
    pageControl.currentPage = 0
    pageControl.numberOfPages = datasources.count
    super.init(frame: CGRect.zero)
    buildHierarchy()
    setupConstraints()
    configureViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Overrides
  
  override func layoutSubviews() {
    let datasource = getCurrentDatasource()

    if let cornerRadius = datasource.theme.cornerRadius {
      layer.cornerRadius = cornerRadius
    }
    
    if let maskedCorners  = datasource.theme.maskedCorners  {
      layer.maskedCorners  = maskedCorners
    }
    
    if let masksToBounds = datasource.theme.masksToBounds {
      layer.masksToBounds = masksToBounds
    }
  }
  
  // MARK: - Methods
  
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
  
  
  // MARK: - Private methods

  private func getCurrentDatasource() -> ToolTipViewDatasourceable {
    datasources[currentIndex]
  }
  
  private func animateDatasourceChange(newDatasource: ToolTipViewDatasourceable) {
    UIView.transition(with: contentLabel,
                      duration: 0.25,
                      options: .transitionCrossDissolve,
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
