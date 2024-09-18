import UIKit

class SliderViewController: UIViewController {
    
    private lazy var calculateLabel: UILabel = {
        let label = createLabel(text: "Let's calculate smth: 150 km", textColor: .black)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var percentLabel: UILabel = {
        let label = createLabel(text: "50%", textColor: .blue.withAlphaComponent(0.7))
        label.textAlignment = .right
        return label
    }()
    
    private lazy var sliderView: CustomGradientSlider = {
        let slider = CustomGradientSlider(frame: .zero)
        slider.delegate = self
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = .white
        [sliderView, calculateLabel, percentLabel].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            sliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sliderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sliderView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            calculateLabel.bottomAnchor.constraint(equalTo: sliderView.topAnchor, constant: -30),
            calculateLabel.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor),
            calculateLabel.trailingAnchor.constraint(equalTo: percentLabel.leadingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.topAnchor.constraint(equalTo: calculateLabel.topAnchor),
            percentLabel.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor),
            percentLabel.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createLabel(text: String, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.textColor = textColor
        return label
    }
}

extension SliderViewController: CustomGradientSliderDelegate {
    func changedCalculatedValue(_ value: CGFloat) {
        let intValue = Int(round(value))
        let pxValue = Int((intValue * 300) / 100)
        percentLabel.text = "\(intValue)%"
        let title = "Let's calculate smth:"
        calculateLabel.text = "\(title) \(pxValue) km"
    }
}
