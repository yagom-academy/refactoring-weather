//
//  WeatherForecast - WeatherTableViewCell.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import Combine

final class WeatherTableViewCell: UITableViewCell {
    static let ReuseIdentifier: String = "WeatherTableViewCell"
    
    private let weatherIcon: UIImageView = .init()
    private let dateLabel: UILabel = .init()
    private let temperatureLabel: UILabel = .init()
    private let weatherLabel: UILabel = .init()
    private let descriptionLabel: UILabel = .init()
    
    private var imageFetcher: ImageFetcher?
    private var cancellables: Set<AnyCancellable> = .init()
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
        reset()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    private func reset() {
        weatherIcon.image = UIImage(systemName: "arrow.down.circle.dotted")
        dateLabel.text = "0000-00-00 00:00:00"
        temperatureLabel.text = "00℃"
        weatherLabel.text = "~~~"
        descriptionLabel.text = "~~~~~"
        cancellables.removeAll()
    }
}

// MARK: Layout Views
extension WeatherTableViewCell {
    private func layoutViews() {
        let dashLabel: UILabel = .init()
        
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
}

// MARK: Update UI
extension WeatherTableViewCell {
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
        
        fetchIconImage(icon)
    }
    
    private func fetchIconImage(_ iconImageUrlString: String) {
        guard let url: URL = URL(string: iconImageUrlString) else { return }
        imageFetcher?.loadImage(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    // handle error
                    print(error)
                }
            }, receiveValue: { [weak self] fetchedImage in
                guard let self else { return }
                
                weatherIcon.image = fetchedImage
            }).store(in: &cancellables)
    }
}
