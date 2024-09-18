import UIKit

protocol CustomGradientSliderDelegate: AnyObject {
    func changedCalculatedValue(_ value: CGFloat)
}

final class CustomGradientSlider: UIControl {
    weak var delegate: CustomGradientSliderDelegate?
    
    var minimumValue: CGFloat = .zero {
        didSet {
            updateGradientSliderLayerFrames()
        }
    }
    
    var maximumValue: CGFloat = 1 {
        didSet {
            updateGradientSliderLayerFrames()
        }
    }
    
    var value: CGFloat = .zero {
        didSet {
            updateGradientSliderLayerFrames()
        }
    }
    
    var trackTintColor: UIColor = UIColor.black.withAlphaComponent(0.2) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var height: CGFloat = 30 {
        didSet {
            updateGradientSliderLayerFrames()
        }
    }
    
    var trackHighlightTintColor: UIColor? {
        didSet {
            sliderGradientLayer.colors = [UIColor.blue.cgColor, UIColor.cyan.cgColor]
            trackLayer.setNeedsDisplay()
        }
    }
    
    private let trackLayer = CustomSliderTrackLayer()
    private let sliderGradientLayer = CAGradientLayer()
    private var previousLocation = CGPoint()
    
    override var frame: CGRect {
        didSet {
            updateGradientSliderLayerFrames()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupGradientSlider()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradientSlider() {
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        sliderGradientLayer.startPoint = CGPoint(x: 0, y: 0)
        sliderGradientLayer.endPoint = CGPoint(x: 1, y: 1)
        sliderGradientLayer.colors = [UIColor.blue.cgColor, UIColor.cyan.cgColor]
        trackLayer.addSublayer(sliderGradientLayer)
    }
    
    private func updateGradientSliderLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        trackLayer.frame = CGRect(x: .zero, y: bounds.midY - (height / 2), width: bounds.width, height: height)
        trackLayer.cornerRadius = height / 2
        trackLayer.masksToBounds = true
        let gradientWidth = positionForSliderValue(value)
        sliderGradientLayer.frame = CGRect(x: .zero, y: .zero, width: gradientWidth, height: height)
        sliderGradientLayer.cornerRadius = height / 2
        trackLayer.setNeedsDisplay()
        CATransaction.commit()
    }
    
    func positionForSliderValue(_ value: CGFloat) -> CGFloat {
        bounds.width * (value / maximumValue)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientSliderLayerFrames()
    }
}

extension CustomGradientSlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
        previousLocation = location
        value += deltaValue
        value = boundValue(value, toLowerValue: minimumValue, upperValue: maximumValue)
        sendActions(for: .valueChanged)
        delegate?.changedCalculatedValue(value)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        delegate?.changedCalculatedValue(value)
    }
    
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
        min(max(value, lowerValue), upperValue)
    }
}

class CustomSliderTrackLayer: CALayer {
    weak var rangeSlider: CustomGradientSlider?
    
    override func draw(in ctx: CGContext) {
        guard let slider = rangeSlider else { return }
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.fillPath()
    }
}
