//
//  ViewController.swift
//  timer_app
//
//  Created by User on 21.08.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - Imitial flags and timer

    var counterForWorkMode = 25
    var counterForRestMode = 10
    var timer: Timer?
    var isTimerRunning = false
    var isWorkTime = true
    var isAnimationStarted = false

    // MARK: - Outlets

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var timeLabel: UILabel = {
        let time = UILabel()
        time.textColor = UIColor(hexString: "#c2697c")
        time.text = "00:\(counterForWorkMode)"
        time.textAlignment = .center
        time.font = UIFont.boldSystemFont(ofSize: 55)
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()

    private lazy var playOrPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.tintColor = UIColor(hexString: "#c2697c")
        button.addTarget(self, action: #selector(playPauseButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var timeAndButtonStackView: UIStackView =  {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let backgroundCircle = CAShapeLayer()
    let animatedCircle = CAShapeLayer()

    private lazy var circleImage: UIImageView = {
        let image = UIImage(systemName: "circle.fill")
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        drawBackgroundCircle()
        drawAnimatedCircle()
        setupHierarchy()
        setupLayouts()
    }

    // MARK: - Setup Hierarchy

    private func setupHierarchy() {
        view.insertSubview(imageView, at: 0)
        view.addSubview(circleImage)
        view.addSubview(timeAndButtonStackView)
        timeAndButtonStackView.addArrangedSubview(timeLabel)
        timeAndButtonStackView.addArrangedSubview(playOrPauseButton)
    }

    // MARK: - Setup Layouts

    private func setupLayouts() {

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }

        timeAndButtonStackView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }

        circleImage.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(timeAndButtonStackView.snp.top).offset(-67)
        }
    }

    // MARK: - Actions

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.97,
                                     target: self,
                                     selector: #selector(runningTimer),
                                     userInfo: nil,
                                     repeats: true)
    }

    private func startTimer() {
        isTimerRunning = true
        isAnimationStarted = true
        playOrPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        runTimer()
        circleImage.tintColor = UIColor(hexString: "#c2697c")
        animationForWorkMode()
    }

    private func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        playOrPauseButton.setImage(UIImage(named: "play"), for: .normal)
        pauseAnimation()
    }

    @objc func playPauseButtonPressed() {
        if isTimerRunning {
            stopTimer()
        } else if !isTimerRunning && !isAnimationStarted {
            startTimer()
        } else if !isTimerRunning && isAnimationStarted {
            resumeAnimation()
        }
    }

    @objc func runningTimer() {
        if isWorkTime {
            if counterForWorkMode > 0 {
                counterForWorkMode -= 1
                guard counterForWorkMode >= 10 else { return timeLabel.text = "00:0\(counterForWorkMode)" }
                timeLabel.text = "00:\(counterForWorkMode)"
            } else if counterForWorkMode == 0 {
                isWorkTime = false
                counterForRestMode = 10
                timeLabel.text = "00:\(counterForRestMode)"
                timeLabel.textColor = UIColor(hexString: "#429e5c")
                circleImage.tintColor = UIColor(hexString: "#429e5c")
                playOrPauseButton.tintColor = UIColor(hexString: "#429e5c")
                animatedCircle.strokeColor = UIColor(hexString: "#429e5c").cgColor
                animationForRestMode()
            }
        } else if !isWorkTime {
            if counterForRestMode > 0 {
                counterForRestMode -= 1
                guard counterForRestMode >= 10 else { return timeLabel.text = "00:0\(counterForRestMode)" }
                timeLabel.text = "00:\(counterForRestMode)"
            } else if counterForRestMode == 0 {
                isWorkTime = true
                counterForWorkMode = 25
                timeLabel.text = "00:\(counterForWorkMode)"
                timeLabel.textColor = UIColor(hexString: "#c2697c")
                circleImage.tintColor = UIColor(hexString: "#c2697c")
                playOrPauseButton.tintColor = UIColor(hexString: "#c2697c")
                animatedCircle.strokeColor = UIColor(hexString: "#c2697c").cgColor
                animationForWorkMode()
            }
        }
    }

    private func drawBackgroundCircle() {
        let center = view.center
        let path = UIBezierPath(arcCenter: center,
                                radius: 150,
                                startAngle: -CGFloat.pi / 2,
                                endAngle: 2 * CGFloat.pi,
                                clockwise: true)
        backgroundCircle.path = path.cgPath
        backgroundCircle.fillColor = UIColor.clear.cgColor
        backgroundCircle.lineWidth = 8
        backgroundCircle.strokeColor = UIColor.clear.cgColor
        backgroundCircle.strokeEnd = 1
        view.layer.addSublayer(backgroundCircle)
    }

    private func drawAnimatedCircle() {
        let center = view.center
        let path = UIBezierPath(arcCenter: center,
                                radius: 150,
                                startAngle: -CGFloat.pi / 2,
                                endAngle: 2 * CGFloat.pi,
                                clockwise: true)
        animatedCircle.path = path.cgPath
        animatedCircle.fillColor = UIColor.clear.cgColor
        animatedCircle.lineWidth = 8
        animatedCircle.strokeColor = UIColor(hexString: "#c2697c").cgColor
        animatedCircle.strokeEnd = 0
        animatedCircle.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(animatedCircle)
    }

    private func animationForWorkMode() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(counterForWorkMode)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        basicAnimation.speed = 0.79856
        animatedCircle.add(basicAnimation, forKey: "basicAnimation")
        imageView.layer.add(basicAnimation, forKey: "basicAnimation")
    }

    private func animationForRestMode() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(counterForRestMode)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        basicAnimation.speed = 0.785
        animatedCircle.add(basicAnimation, forKey: "basicAnimation")
    }

    private func pauseAnimation(){
        let pausedTime : CFTimeInterval = animatedCircle.convertTime(CACurrentMediaTime(), from: nil)
        animatedCircle.speed = 0.0
        animatedCircle.timeOffset = pausedTime
    }

    private func resumeAnimation(){
        let pausedTime = animatedCircle.timeOffset
        animatedCircle.speed = 1.0
        animatedCircle.timeOffset = 0.0
        animatedCircle.beginTime = 0.0
        let timeSincePause = animatedCircle.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        animatedCircle.beginTime = timeSincePause
        isTimerRunning = true
        playOrPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        runTimer()
    }

}

