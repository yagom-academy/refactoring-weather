//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import Combine

class WeatherTableViewCell: UITableViewCell {
    static let ReuseIdentifier: String = "WeatherTableViewCell"
    
    var weatherIcon: UIImageView!
    var dateLabel: UILabel!
    var temperatureLabel: UILabel!
    var weatherLabel: UILabel!
    var descriptionLabel: UILabel!
    
    private var imageFetcher: ImageFetcher?
    private var cancellable: Set<AnyCancellable> = .init()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layViews()
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private func layViews() {
        weatherIcon = UIImageView()
        dateLabel = UILabel()
        temperatureLabel = UILabel()
        weatherLabel = UILabel()
        let dashLabel: UILabel = UILabel()
        descriptionLabel = UILabel()
        
        let labels: [UILabel] = [dateLabel, temperatureLabel, weatherLabel, dashLabel, descriptionLabel]
        
        labels.forEach { label in
            label.textColor = .black
            label.font = .preferredFont(forTextStyle: .body)
            label.numberOfLines = 1
        }
        
        let weatherStackView: UIStackView = UIStackView(arrangedSubviews: [
            weatherLabel,
            dashLabel,
            descriptionLabel
        ])
        
        descriptionLabel.setContentHuggingPriority(.defaultLow,
                                                   for: .horizontal)
        
        weatherStackView.axis = .horizontal
        weatherStackView.spacing = 8
        weatherStackView.alignment = .center
        weatherStackView.distribution = .fill
        
        
        let verticalStackView: UIStackView = UIStackView(arrangedSubviews: [
            dateLabel,
            temperatureLabel,
            weatherStackView
        ])
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .leading
        
        let contentsStackView: UIStackView = UIStackView(arrangedSubviews: [
            weatherIcon,
            verticalStackView
        ])
               
        contentsStackView.axis = .horizontal
        contentsStackView.spacing = 16
        contentsStackView.alignment = .center
        contentsStackView.distribution = .fill
        contentsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(contentsStackView)
                
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            contentsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            weatherIcon.widthAnchor.constraint(equalTo: weatherIcon.heightAnchor),
            weatherIcon.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func reset() {
        weatherIcon.image = UIImage(systemName: "arrow.down.circle.dotted")
        dateLabel.text = "0000-00-00 00:00:00"
        temperatureLabel.text = "00℃"
        weatherLabel.text = "~~~"
        descriptionLabel.text = "~~~~~"
        cancellable.removeAll()
    }
    
    func setImageFetcher(_ imageFetcher: ImageFetcher) {
        self.imageFetcher = imageFetcher
    }
    
    func updateUI(
        weatherMain: String,
        weatherDescription: String,
        temperature: String,
        date: String,
        icon: String
    ) {
        weatherLabel.text = weatherMain
        descriptionLabel.text = weatherDescription
        temperatureLabel.text = temperature
        dateLabel.text = date
        
        guard let url = URL(string: icon) else { return }
        imageFetcher?.loadImage(url: url)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    // handle error (placeholder 이미지 노출 등)
                    print(error)
                }
            } receiveValue: { [weak self] fetchedImage in
                guard let self else { return }
                
                weatherIcon.image = fetchedImage
            }.store(in: &cancellable)
    }
}