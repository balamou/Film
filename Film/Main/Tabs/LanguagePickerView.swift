//
//  LanguagePickerView.swift
//  Film
//
//  Created by Michel Balamou on 2019-09-21.
//  Copyright © 2019 ElasticPanda. All rights reserved.
//

import UIKit

class LanguagePickerView: UIPickerView {
    
    let languages = Language.default
    let pickerRowHeight: CGFloat = 30
    var onSelectLanguage: (String) -> Void
    
    init(onSelectLanguage: @escaping (String) -> Void) {
        self.onSelectLanguage = onSelectLanguage
        super.init(frame: .zero)
        
        backgroundColor = Colors.backgroundColor
        tintColor = .white
        
        delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectLanguage(_ language: String) {
        let indexOfLanguageSelected = languages.firstIndex { $0.serverValue == language } ?? 0
        selectRow(indexOfLanguageSelected, inComponent: 0, animated: false)
    }
    
    func languageSelected() -> String {
        let row = selectedRow(inComponent: 0)
        
        return languages[row].localized
    }
}

extension LanguagePickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onSelectLanguage(languages[row].localized)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pickerRowHeight
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row].localized
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let language = languages[row].localized
        let component = NSAttributedString(string: language, attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        
        return component
    }
}

extension LanguagePickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
}

