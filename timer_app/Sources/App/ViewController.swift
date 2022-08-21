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

    var counterForWork = 25
    var counterForRest = 10
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
        time.text = "00:\(counterForWork)"
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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupLayouts()
    }

    // MARK: - Setup Hierarchy

    private func setupHierarchy() {
        view.insertSubview(imageView, at: 0)
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
    }

    private func stopTimer() {
        isTimerRunning = false
        timer?.invalidate()
        playOrPauseButton.setImage(UIImage(named: "play"), for: .normal)
    }

    @objc func playPauseButtonPressed() {
        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }

    @objc func runningTimer() {
        if isWorkTime {
            if counterForWork > 0 {
                counterForWork -= 1
                guard counterForWork >= 10 else { return timeLabel.text = "00:0\(counterForWork)" }
                timeLabel.text = "00:\(counterForWork)"
            } else if counterForWork == 0 {
                isWorkTime = false
                counterForRest = 10
                timeLabel.text = "00:\(counterForRest)"
                timeLabel.textColor = UIColor(hexString: "#429e5c")
                playOrPauseButton.tintColor = UIColor(hexString: "#429e5c")
            }
        } else if !isWorkTime {
            if counterForRest > 0 {
                counterForRest -= 1
                guard counterForRest >= 10 else { return timeLabel.text = "00:0\(counterForRest)" }
                timeLabel.text = "00:\(counterForRest)"
            } else if counterForRest == 0 {
                isWorkTime = true
                counterForWork = 25
                timeLabel.text = "00:\(counterForWork)"
                timeLabel.textColor = UIColor(hexString: "#c2697c")
                playOrPauseButton.tintColor = UIColor(hexString: "#c2697c")
            }
        }
    }

}

