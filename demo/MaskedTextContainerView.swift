//
//  MaskedTextContainerView.swift
//  demo
//
//  Created by Johan Halin on 26/02/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class MaskedTextContainerView: UIView {
    private let labelCount: Int
    
    private let contentView1 = UIView()
    private let contentView2 = UIView()
    private let contentView3 = UIView()
    private let contentView4 = UIView()
    
    private var label1: UILabel? = nil
    private var label2: UILabel? = nil
    private var label3: UILabel? = nil
    private var label4: UILabel? = nil

    init(frame: CGRect, labelCount: Int) {
        assert(labelCount >= 2 && labelCount <= 4)
        
        self.labelCount = labelCount
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        self.contentView1.frame = self.bounds
        self.contentView2.frame = self.bounds
        
        self.contentView1.mask = MaskView(frame: self.bounds, offset: 2, count: labelCount)
        self.contentView2.mask = MaskView(frame: self.bounds, offset: 6, count: labelCount)

        self.label1 = addLabel(toView: self.contentView1)
        self.label2 = addLabel(toView: self.contentView2)

        self.addSubview(self.contentView1)
        self.addSubview(self.contentView2)

        if labelCount >= 3 {
            self.addSubview(self.contentView3)
            self.contentView3.frame = self.bounds
            self.contentView3.mask = MaskView(frame: self.bounds, offset: 10, count: labelCount)
            self.label3 = addLabel(toView: self.contentView3)
        }

        if labelCount >= 4 {
            self.addSubview(self.contentView4)
            self.contentView4.frame = self.bounds
            self.contentView4.mask = MaskView(frame: self.bounds, offset: 14, count: labelCount)
            self.label4 = addLabel(toView: self.contentView4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLabel(toView parent: UIView) -> UILabel {
        let label = UILabel(frame: parent.bounds)
        label.font = UIFont.boldSystemFont(ofSize: 400)
        label.lineBreakMode = .byClipping
        label.textColor = UIColor(white: 0.7, alpha: 1.0)
        parent.addSubview(label)
        
        return label
    }
    
    func setText(text1: String, text2: String) {
        assert(self.labelCount == 2)
        
        self.label1?.text = text1
        self.label2?.text = text2
    }
    
    func setText(text1: String, text2: String, text3: String) {
        assert(self.labelCount == 3)

        self.label1?.text = text1
        self.label2?.text = text2
        self.label3?.text = text3
    }
    
    func setText(text1: String, text2: String, text3: String, text4: String) {
        assert(self.labelCount == 4)

        self.label1?.text = text1
        self.label2?.text = text2
        self.label3?.text = text3
        self.label4?.text = text4
    }
}
