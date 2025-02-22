//
//  MaskVerticalView.swift
//  demo
//
//  Created by Johan Halin on 27/02/2019.
//  Copyright © 2019 Dekadence. All rights reserved.
//

import UIKit

class MaskVerticalView: UIView {
    private let startOffset: CGFloat
    private let count: Int
    
    init(frame: CGRect, offset: CGFloat, count: Int) {
        self.startOffset = offset
        self.count = count
        
        super.init(frame: frame)
        
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        var position = self.startOffset
        
        while position < rect.height {
            context.setStrokeColor(UIColor.white.cgColor)
            context.setLineWidth(6.0 / self.contentScaleFactor)
            context.move(to: CGPoint(x: 0, y: position - 2))
            context.addLine(to: CGPoint(x: rect.width, y: position - 2))
            context.strokePath()
            position += 4.0 * CGFloat(self.count)
        }
    }
}
