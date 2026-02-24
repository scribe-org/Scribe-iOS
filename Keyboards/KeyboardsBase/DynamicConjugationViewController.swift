// SPDX-License-Identifier: GPL-3.0-or-later

/// Dynamic view controller for arbitrary-depth navigation.
/// Handles conjugations and declensions.

import UIKit

class DynamicConjugationViewController: UIViewController {

  // MARK: UI Components

  private var leftArrowButton: UIButton!
  private var rightArrowButton: UIButton!
  private var buttonContainerView: UIView!

  // MARK: Navigation Data

  // For tree navigation (conjugations and variant declensions).
  private var navigationStack: [NavigationLevel] = []

  // For linear navigation (declension cases).
  private var linearCases: [NavigationLevel]?
  private var currentCaseIndex: Int = 0

  private weak var commandBar: CommandBar?

  // MARK: Initialization

  // Tree navigation (conjugations).
  init(navigationTree: NavigationLevel, commandBar: CommandBar) {
    self.commandBar = commandBar
    super.init(nibName: nil, bundle: nil)
    navigationStack = [navigationTree]
  }

  // Linear navigation (declensions).
  init(linearCases: [NavigationLevel], commandBar: CommandBar, startingIndex: Int = 0) {
    self.commandBar = commandBar
    self.linearCases = linearCases
    self.currentCaseIndex = startingIndex
    super.init(nibName: nil, bundle: nil)

    if !linearCases.isEmpty && startingIndex < linearCases.count {
      navigationStack = [linearCases[startingIndex]]
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = keyboardBgColor
    setupUI()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    if buttonContainerView.subviews.isEmpty {
      displayCurrentLevel()
    }
  }

  // MARK: Setup

  /// Sets up the UI components.
  private func setupUI() {
    buttonContainerView = UIView()
    buttonContainerView.backgroundColor = .clear
    buttonContainerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(buttonContainerView)

    leftArrowButton = UIButton(type: .system)
    leftArrowButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    leftArrowButton.tintColor = keyCharColor
    leftArrowButton.backgroundColor = keyColor
    leftArrowButton.layer.cornerRadius = keyCornerRadius
    leftArrowButton.layer.shadowColor = keyShadowColor
    leftArrowButton.layer.shadowOffset = CGSize(width: 0, height: 1)
    leftArrowButton.layer.shadowOpacity = 1.0
    leftArrowButton.layer.shadowRadius = 0
    leftArrowButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
    leftArrowButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(leftArrowButton)

    rightArrowButton = UIButton(type: .system)
    rightArrowButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    rightArrowButton.tintColor = keyCharColor
    rightArrowButton.backgroundColor = keyColor
    rightArrowButton.layer.cornerRadius = keyCornerRadius
    rightArrowButton.layer.shadowColor = keyShadowColor
    rightArrowButton.layer.shadowOffset = CGSize(width: 0, height: 1)
    rightArrowButton.layer.shadowOpacity = 1.0
    rightArrowButton.layer.shadowRadius = 0
    rightArrowButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
    rightArrowButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(rightArrowButton)

    NSLayoutConstraint.activate([
      leftArrowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
      leftArrowButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
      leftArrowButton.widthAnchor.constraint(equalToConstant: 40),
      leftArrowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),

      rightArrowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
      rightArrowButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
      rightArrowButton.widthAnchor.constraint(equalToConstant: 40),
      rightArrowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),

      buttonContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
      buttonContainerView.leadingAnchor.constraint(equalTo: leftArrowButton.trailingAnchor, constant: 4),
      buttonContainerView.trailingAnchor.constraint(equalTo: rightArrowButton.leadingAnchor, constant: -4),
      buttonContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
    ])
  }

  // MARK: Display

  /// Displays the current navigation level.
  private func displayCurrentLevel() {
    buttonContainerView.subviews.forEach { $0.removeFromSuperview() }

    guard let currentLevel = navigationStack.last else {
      commandBar?.text = commandPromptSpacing + "No data"
      return
    }

    commandBar?.text = commandPromptSpacing + currentLevel.title
    commandBar?.isShowingInfoButton = false

    let options = currentLevel.options
    guard !options.isEmpty else {
      commandBar?.text = commandPromptSpacing + "No options available"
      return
    }

    // Create button grid.
    let count = options.count
    let (rows, cols) = getGridLayout(forCount: count)
    let spacing: CGFloat = 4

    let containerWidth = buttonContainerView.bounds.width
    let containerHeight = buttonContainerView.bounds.height
    let buttonWidth = (containerWidth - CGFloat(cols + 1) * spacing) / CGFloat(cols)
    let buttonHeight = (containerHeight - CGFloat(rows + 1) * spacing) / CGFloat(rows)

    for (index, option) in options.enumerated() {
      let row: Int
      let col: Int
      if cols == 1 {
        row = index
        col = 0
      } else {
        col = index / rows
        row = index % rows
     }

      let button = UIButton(type: .custom)
      button.frame = CGRect(
        x: CGFloat(col) * (buttonWidth + spacing) + spacing,
        y: CGFloat(row) * (buttonHeight + spacing) + spacing,
        width: buttonWidth,
        height: buttonHeight
      )

      button.setTitleColor(keyCharColor, for: .normal)
      button.backgroundColor = keyColor
      button.titleLabel?.font = .systemFont(ofSize: 16)
      button.titleLabel?.numberOfLines = 0
      button.titleLabel?.adjustsFontSizeToFitWidth = true
      button.titleLabel?.minimumScaleFactor = 0.6
      button.titleLabel?.textAlignment = .center
      button.contentVerticalAlignment = .center
      button.layer.cornerRadius = keyCornerRadius
      button.layer.shadowColor = keyShadowColor
      button.layer.shadowOffset = CGSize(width: 0, height: 1)
      button.layer.shadowOpacity = 1.0
      button.layer.shadowRadius = 0
      button.tag = index
      button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)

      // Determine the display value.
      let displayValue: String?
      switch option.node {
      case .finalValue(let value):
        displayValue = value.isEmpty ? nil : value
      case .nextLevel(_, let value):
        displayValue = value
      }

      // Add label at top-left.
      let label = UILabel()
      label.text = "  " + option.label
      label.font = .systemFont(ofSize: 11)
      label.textColor = commandBarPlaceholderColor
      label.translatesAutoresizingMaskIntoConstraints = false
      button.addSubview(label)

      // Set value in center (if exists).
      if let value = displayValue {
        button.setTitle(value, for: .normal)
      }

      NSLayoutConstraint.activate([
        label.topAnchor.constraint(equalTo: button.topAnchor, constant: 2),
        label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 2)
      ])

      buttonContainerView.addSubview(button)
    }

    updateArrowButtons()
  }

  /// Handles option button taps.
  @objc private func optionButtonTapped(_ sender: UIButton) {
    guard let currentLevel = navigationStack.last,
          sender.tag < currentLevel.options.count else {
      return
    }

    let selectedOption = currentLevel.options[sender.tag]

    switch selectedOption.node {
    case .nextLevel(let nextLevel, _):
      // Navigate deeper.
      navigationStack.append(nextLevel)
      displayCurrentLevel()

    case .finalValue(let value):
      // Skip empty values.
      guard !value.isEmpty else { return }

      // Insert text and close.
      proxy.insertText(value + " ")
      closeTapped()
    }
  }

  /// Handles left arrow button tap.
  @objc private func leftArrowTapped() {
    if let cases = linearCases {
      // Linear mode: navigate between cases or go back in tree.
      if navigationStack.count > 1 {
        // In a variant - go back.
        navigationStack.removeLast()
        displayCurrentLevel()
      } else if currentCaseIndex > 0 {
        // At root level - go to previous case.
        currentCaseIndex -= 1
        navigationStack = [cases[currentCaseIndex]]
        displayCurrentLevel()
      }
    } else {
      // Tree mode: just go back.
      if navigationStack.count > 1 {
        navigationStack.removeLast()
        displayCurrentLevel()
      }
    }
  }

  /// Handles right arrow button tap.
  @objc private func rightArrowTapped() {
    if let cases = linearCases {
      // Linear mode: navigate to next case.
      if navigationStack.count > 1 {
        // In a variant - can't navigate cases.
        return
      } else if currentCaseIndex < cases.count - 1 {
        // At root level - go to next case.
        currentCaseIndex += 1
        navigationStack = [cases[currentCaseIndex]]
        displayCurrentLevel()
      }
    }
    // Tree mode: right arrow does nothing.
  }

  /// Updates the enabled state of arrow buttons.
  private func updateArrowButtons() {
    if let cases = linearCases {
      // Linear mode.
      if navigationStack.count > 1 {
        // In a variant - left goes back, right disabled.
        leftArrowButton.isEnabled = true
        leftArrowButton.alpha = 1.0
        rightArrowButton.isEnabled = false
        rightArrowButton.alpha = 1.0
      } else {
        // At root case level - arrows navigate cases.
        leftArrowButton.isEnabled = currentCaseIndex > 0
        rightArrowButton.isEnabled = currentCaseIndex < cases.count - 1
      }
    } else {
      // Tree mode - left goes back, right disabled.
      leftArrowButton.isEnabled = navigationStack.count > 1

      rightArrowButton.isEnabled = false
    }
  }

  /// Closes the dynamic conjugation view.
  @objc private func closeTapped() {
    commandState = .idle
    autoActionState = .suggest

    let kvc = parent as? KeyboardViewController

    removeFromParent()
    view.removeFromSuperview()

    kvc?.loadKeys()
    kvc?.conditionallySetAutoActionBtns()
  }

  /// Determines grid layout based on button count.
  /// - Parameters:
  ///   - count: The number of buttons to display.
  private func getGridLayout(forCount count: Int) -> (rows: Int, cols: Int) {
    switch count {
    case 1: return (1, 1)
    case 2: return (2, 1)
    case 3: return (3, 1)
    case 4: return (2, 2)
    case 6: return (3, 2)
    default: return (count, 1)
    }
  }
}
