//
//  PieChart.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 24/01/23.
//

import Foundation
import UIKit

extension Double{
    func cgRadians()->CGFloat{
        return self * CGFloat(Double.pi) / 180.0
    }
}




extension UIBezierPath{

    convenience init(circleSegmentCenter center:CGPoint, radius:CGFloat, startAngle:CGFloat, endAngle:CGFloat){
        self.init()
        
        self.move(to: center)
        self.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        self.close()
    }

}




//class PieChartView: UIView{
//    
//   
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//       
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    
////    var dataSet: [(sample: Double , colour: UIColor)] = [(100,.black),(150,.systemCyan),(50,.magenta)]
//    var dataSet = [(sample: Double , colour: UIColor)](){
//        didSet{
//            self.setNeedsDisplay()
//        }
//    }
//    
//    var radius = 10.0{
//        didSet{
//            self.setNeedsDisplay()
//        }
//    }
//    
//    
//    func samplePie(center: CGPoint, radius: CGFloat){
//        
//       
//        let total = dataSet.reduce(0.0){ $0 + $1.sample }
//        let chartData = dataSet.map(){ ($0.sample/total,$0.colour) }
//        
//        var currentAngle = 0.0
//        for data in chartData{
//            let delta = (data.0 * 360)
//            
//            let sector = UIBezierPath(circleSegmentCenter: center, radius: radius, startAngle: currentAngle.cgRadians(), endAngle: currentAngle.cgRadians() + delta.cgRadians())
//            currentAngle += delta
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.path = sector.cgPath
//            shapeLayer.fillColor = data.1.cgColor
//            shapeLayer.strokeColor = UIColor.white.cgColor
//            
//        
//            
//            self.layer.insertSublayer(shapeLayer, at: 0)
//            
//            shapeLayers.append(shapeLayer)
//            
//            
//            
//            
////            shapeLayer.needsDisplayOnBoundsChange = true
//        }
//        
//        let hole = UIBezierPath(ovalIn: .init(x: center.x - radius/2, y: center.y - radius/2, width: radius, height: radius))
//        let holeLayer = CAShapeLayer()
//        holeLayer.strokeColor = UIColor.white.withAlphaComponent(0.1).cgColor
//        holeLayer.lineWidth = 10
//        holeLayer.fillColor = UIColor.black.cgColor
//        holeLayer.path = hole.cgPath
//        self.layer.insertSublayer(holeLayer, at: UInt32(shapeLayers.count))
////        self.layer.addSublayer(holeLayer)
//        shapeLayers.append(holeLayer)
//        
//    }
//    
//    var shapeLayers = [CAShapeLayer]()
//    
//    override func draw(_ rect: CGRect) {
//
//            for sublayer in shapeLayers{
//                sublayer.removeFromSuperlayer()
//            }
//        
//        backgroundColor = .gray
//        print(#function)
//        print(rect)
////        samplePie(center: CGPoint(x: bounds.midX, y: bounds.midY),radius: radius)
//        samplePie(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius)
//        
//        for sublayer in shapeLayers{
//           
//            let textLayer = CATextLayer()
//            textLayer.string = String(100)
//            textLayer.fontSize = 100
//            textLayer.frame = sublayer.frame
//            sublayer.addSublayer(textLayer)
//            
//        }
//        
//        
//        
//    }
//    
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.needsDisplayOnBoundsChange = true
//    }
//   
//}
