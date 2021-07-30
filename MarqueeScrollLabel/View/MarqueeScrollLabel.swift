//
//  MarqueeScrollLabel.swift
//  MarqueeScrollLabel
//
//  Created by Alexander Golikov on 7/16/21.
//

import UIKit

@IBDesignable
open class MarqueeScrollLabel: UILabel {

    private lazy var label: UILabel  = {
        let label = UILabel()
        return label
    }()

    @IBInspectable override public var text: String? {
        didSet {
            label.text = text
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    @IBInspectable public var animating: Bool = false {
        didSet {
            setupMarqueeAnimation()
        }
    }

    @IBInspectable public var enableTextFade: Bool = true {
        didSet {
            setupMarqueeAnimation()
        }
    }

    private let gradientMask = CAGradientLayer()

    private let defaultFont = UIFont.systemFont(ofSize: 17)

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        subscribeToSystemNotifications()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
        subscribeToSystemNotifications()
    }

    private func setupView() {
        clipsToBounds = true
        label.numberOfLines = 1
        addSubview(label)

        // Setup gradient mask for fade effect on left and right label edges
        gradientMask.shouldRasterize = true
        gradientMask.rasterizationScale = UIScreen.main.scale
        gradientMask.startPoint = CGPoint(x:0.0, y:0.5)
        gradientMask.endPoint = CGPoint(x:1.0, y:0.5)
        let transparent = UIColor.clear.cgColor
        let opaque = UIColor.black.cgColor
        gradientMask.colors = [transparent, opaque, opaque, transparent]
        gradientMask.locations = [0, 0.08, 0.92, 1]
    }

    private func subscribeToSystemNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(restartAnimation), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    // MARK: - Deinit

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - IB

    private func connectLabelProperties() {
        let uiLabelProperties = ["font", "textColor", "textAlignment", "lineBreakMode", "enabled",
                                 "shadowOffset", "shadowColor", "userInteractionEnabled"]

        text = super.text
        label.backgroundColor = super.backgroundColor ?? UIColor.clear
        for property in uiLabelProperties {
            label.setValue(super.value(forKey: property), forKey: property)
        }
    }

    override open func awakeFromNib() {
        super.awakeFromNib()

        connectLabelProperties()
    }

    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        connectLabelProperties()
    }

    // MARK: - Overrides

    open override var intrinsicContentSize: CGSize {
        guard let text = text else {
            return .zero
        }

        return CGSize(width: text.size(withAttributes: [.font: label.font ?? defaultFont]).width, height: label.intrinsicContentSize.height)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        setupMarqueeAnimation()
    }

    open override func draw(_ layer: CALayer, in ctx: CGContext) {
        // Do nothing here in order to prevent super class UILayer to draw its content
    }

    // MARK: - Scroll animation handling

    private func setupMarqueeAnimation() {
        guard let text = text else {
            return
        }

        label.layer.removeAllAnimations()
        let textWidth = text.size(withAttributes: [.font: label.font ?? defaultFont]).width
        if textWidth < layer.bounds.width {
            label.text = text
            layer.mask = nil
            label.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        } else {
            let doubledText = text + "        " + text
            let doubledTextWidth = doubledText.size(withAttributes: [.font: label.font ?? defaultFont]).width

            label.text = doubledText

            if animating {
                let animation = CABasicAnimation(keyPath: "transform.translation.x")
                animation.toValue = textWidth - doubledTextWidth
                animation.repeatCount = .infinity
                animation.beginTime = CACurrentMediaTime() + 0.5
                animation.duration = 6 + CFTimeInterval(textWidth/layer.bounds.width)
                label.layer.add(animation, forKey: "labelAnimation")
            }

            if enableTextFade && animating {
                gradientMask.frame = layer.bounds
                layer.mask = gradientMask
                label.frame = CGRect(x: bounds.width*0.08, y: 0, width: label.intrinsicContentSize.width, height: bounds.height)
            } else {
                layer.mask = nil
                label.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width, height: bounds.height)
            }
        }
    }

    @objc private func restartAnimation() {
        if animating {
            setupMarqueeAnimation()
        }
    }
}
