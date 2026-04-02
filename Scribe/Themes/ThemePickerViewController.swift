// SPDX-License-Identifier: GPL-3.0-or-later

// Keyboard theme picker — Gboard-style sectioned layout.

import UIKit

// MARK: - Section model

private struct ThemeSection {
    let title: String
    let themes: [KeyboardTheme?] // nil = "Add" placeholder card
}

// MARK: - ThemePickerViewController

final class ThemePickerViewController: UIViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 20, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.alwaysBounceVertical = true
        cv.register(ThemeCell.self, forCellWithReuseIdentifier: ThemeCell.reuseId)
        cv.register(AddThemeCell.self, forCellWithReuseIdentifier: AddThemeCell.reuseId)
        cv.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseId
        )
        return cv
    }()

    private let sections: [ThemeSection] = [
        ThemeSection(title: "My themes", themes: [
            nil, // + card
            .default, .midnight
        ]),
        ThemeSection(title: "Default", themes: [
            .snow, .default, .highContrastLight, .highContrastDark
        ]),
        ThemeSection(title: "Colours", themes: [
            .ocean, .forest, .rose, .violet, .teal, .crimson,
            .lavender, .mint, .peach, .sand, .slate, .sepia,
            .terracotta, .sakura, .autumn, .deepSea, .berlin,
            .paris, .madrid, .stockholm
        ]),
        ThemeSection(title: "Gradient", themes: [
            .aurora, .sunset, .galaxy, .ember,
            .cottonCandy, .citrus, .arctic
        ]),
        ThemeSection(title: "Neon", themes: [
            .neonCyber, .neonPulse, .neonLime
        ]),
        ThemeSection(title: "Accessible", themes: [
            .highContrastDark, .highContrastLight, .warmAccessible
        ])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString(
            "i18n.app.settings.menu.keyboard_theme", value: "Keyboard theme", comment: ""
        )
        view.backgroundColor = UIColor.systemGroupedBackground

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func cardSize(in width: CGFloat) -> CGSize {
        let itemW = (width - 24) / 3   // 3 columns, 2 gaps of 12
        // Extra height for the name label below the card preview
        return CGSize(width: itemW, height: itemW * 0.75 + 22)
    }
}

// MARK: - UICollectionViewDataSource

extension ThemePickerViewController: UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int { sections.count }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].themes.count
    }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let themeOrNil = sections[indexPath.section].themes[indexPath.item]

        if themeOrNil == nil {
            // "+" add card
            let cell = cv.dequeueReusableCell(withReuseIdentifier: AddThemeCell.reuseId, for: indexPath) as! AddThemeCell
            return cell
        }

        let theme = themeOrNil!
        let cell = cv.dequeueReusableCell(withReuseIdentifier: ThemeCell.reuseId, for: indexPath) as! ThemeCell
        cell.configure(with: theme, isSelected: theme.id == ThemeManager.shared.currentThemeId)
        return cell
    }

    func collectionView(
        _ cv: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = cv.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseId,
            for: indexPath
        ) as! SectionHeaderView
        header.configure(title: sections[indexPath.section].title)
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension ThemePickerViewController: UICollectionViewDelegate {
    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let theme = sections[indexPath.section].themes[indexPath.item] else {
            // "+" card — coming soon
            let alert = UIAlertController(
                title: "Custom Themes",
                message: "Create your own keyboard theme — coming soon!",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        ThemeManager.shared.apply(theme)
        cv.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ThemePickerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ cv: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        cardSize(in: cv.bounds.width)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection _: Int) -> CGSize {
        CGSize(width: 0, height: 36)
    }
}

// MARK: - SectionHeaderView

private final class SectionHeaderView: UICollectionReusableView {
    static let reuseId = "SectionHeaderView"

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(title: String) { label.text = title }
}

// MARK: - AddThemeCell  ("+" card)

private final class AddThemeCell: UICollectionViewCell {
    static let reuseId = "AddThemeCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.separator.cgColor
        contentView.backgroundColor = .clear

        let plus = UILabel()
        plus.text = "+"
        plus.font = .systemFont(ofSize: 28, weight: .light)
        plus.textColor = UIColor(white: 0.75, alpha: 1)
        plus.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(plus)
        NSLayoutConstraint.activate([
            plus.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plus.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - ThemeCell

private final class ThemeCell: UICollectionViewCell {
    static let reuseId = "ThemeCell"

    private let previewView = KeyboardMiniPreview()
    private let nameLabel = UILabel()
    private let checkBadge = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func buildUI() {
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 2.5
        contentView.layer.borderColor = UIColor.clear.cgColor

        previewView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(previewView)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 11, weight: .medium)
        nameLabel.textColor = .secondaryLabel
        nameLabel.numberOfLines = 1
        contentView.addSubview(nameLabel)

        let cfg = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        checkBadge.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: cfg)
        checkBadge.tintColor = .white
        checkBadge.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkBadge)

        let nameLabelH: CGFloat = 22

        NSLayoutConstraint.activate([
            // Preview fills top portion, name label at bottom
            previewView.topAnchor.constraint(equalTo: contentView.topAnchor),
            previewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -nameLabelH),

            // Name label sits in the bottom strip
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            nameLabel.heightAnchor.constraint(equalToConstant: nameLabelH - 4),

            // Checkmark bottom-right inside preview area
            checkBadge.trailingAnchor.constraint(equalTo: previewView.trailingAnchor, constant: -6),
            checkBadge.bottomAnchor.constraint(equalTo: previewView.bottomAnchor, constant: -6),
            checkBadge.widthAnchor.constraint(equalToConstant: 20),
            checkBadge.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(with theme: KeyboardTheme, isSelected: Bool) {
        previewView.configure(with: theme)
        nameLabel.text = theme.displayName
        // Use a semi-transparent background strip so name is always readable
        nameLabel.backgroundColor = UIColor.systemGroupedBackground.withAlphaComponent(0.92)
        nameLabel.textColor = .label

        contentView.layer.borderColor = isSelected
            ? UIColor(ScribeColor.scribeCTA).cgColor
            : UIColor.clear.cgColor

        checkBadge.isHidden = !isSelected
    }
}

// MARK: - KeyboardMiniPreview

/// Draws a mini keyboard: background + spacebar strip at bottom (Gboard style).
/// Gradient themes get a CAGradientLayer background.
private final class KeyboardMiniPreview: UIView {

    private var bgColor: UIColor = .systemGray6
    private var keyCol: UIColor = .white
    private var specialCol: UIColor = .systemGray3
    private var shadowCol: UIColor = .systemGray4

    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        if gradientLayer.isHidden {
            bgColor.setFill()
            UIBezierPath(rect: rect).fill()
        }

        let pad: CGFloat = rect.width * 0.05
        let gap: CGFloat = rect.width * 0.022
        let rowGap: CGFloat = rect.height * 0.05

        // 3 key rows take up top 65% of height; spacebar strip at bottom
        let keyAreaH = rect.height * 0.62
        let keyH = (keyAreaH - rowGap * 2) / 3
        let r = keyH * 0.30

        // Row 0: 5 keys
        let row0Y = pad * 0.6
        let key0W = (rect.width - pad * 2 - gap * 4) / 5
        for i in 0 ..< 5 {
            let x = pad + CGFloat(i) * (key0W + gap)
            drawKey(ctx: ctx, in: CGRect(x: x, y: row0Y, width: key0W, height: keyH), color: keyCol, radius: r)
        }

        // Row 1: 4 keys (inset)
        let row1Y = row0Y + keyH + rowGap
        let key1W = (rect.width - pad * 2 - gap * 3) / 4
        let row1X = (rect.width - (key1W * 4 + gap * 3)) / 2
        for i in 0 ..< 4 {
            let x = row1X + CGFloat(i) * (key1W + gap)
            drawKey(ctx: ctx, in: CGRect(x: x, y: row1Y, width: key1W, height: keyH), color: keyCol, radius: r)
        }

        // Row 2: shift + 3 + delete
        let row2Y = row1Y + keyH + rowGap
        let avail = rect.width - pad * 2
        let lw = (avail - gap * 4) / 6
        let ww = lw * 1.5
        drawKey(ctx: ctx, in: CGRect(x: pad, y: row2Y, width: ww, height: keyH), color: specialCol, radius: r)
        for i in 0 ..< 3 {
            let x = pad + ww + gap + CGFloat(i) * (lw + gap)
            drawKey(ctx: ctx, in: CGRect(x: x, y: row2Y, width: lw, height: keyH), color: keyCol, radius: r)
        }
        drawKey(ctx: ctx, in: CGRect(x: pad + ww + gap + 3 * (lw + gap), y: row2Y, width: ww, height: keyH), color: specialCol, radius: r)

        // Spacebar strip at bottom
        let spaceY = rect.height - pad * 0.5 - keyH * 0.65
        let spaceW = rect.width * 0.55
        let spaceX = (rect.width - spaceW) / 2
        drawKey(ctx: ctx, in: CGRect(x: spaceX, y: spaceY, width: spaceW, height: keyH * 0.65), color: specialCol, radius: r * 0.8)

        // Small colored dot bottom-right (accent indicator)
        let dotR: CGFloat = 5
        let dotX = rect.width - pad - dotR
        let dotY = rect.height - pad * 0.4 - dotR
        let dotPath = UIBezierPath(ovalIn: CGRect(x: dotX - dotR, y: dotY - dotR, width: dotR * 2, height: dotR * 2))
        keyCol.setFill()
        dotPath.fill()
    }

    private func drawKey(ctx: CGContext, in keyRect: CGRect, color: UIColor, radius: CGFloat) {
        ctx.saveGState()
        ctx.setShadow(offset: CGSize(width: 0, height: 1), blur: 1, color: shadowCol.cgColor)
        let path = UIBezierPath(roundedRect: keyRect, cornerRadius: radius)
        color.setFill()
        path.fill()
        ctx.restoreGState()
    }

    func configure(with theme: KeyboardTheme) {
        bgColor = theme.keyboardBgColor
        keyCol = theme.keyColor
        specialCol = theme.specialKeyColor
        shadowCol = theme.keyShadowColor

        if let (start, end) = theme.gradientColors {
            gradientLayer.colors = [start.cgColor, end.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.isHidden = false
        } else {
            gradientLayer.isHidden = true
        }

        setNeedsDisplay()
    }
}
