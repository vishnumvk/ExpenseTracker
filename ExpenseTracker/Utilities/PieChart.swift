//
//  PieChart.swift
//  ExpenseTracker
//
//  Created by vishnu-pt6278 on 24/01/23.
//

import Foundation
import UIKit

extension CGFloat{
    func radians()->CGFloat{
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
//    var centers = [CGPoint]()
//    var shapeLayers = [CAShapeLayer]()
//    var textLayers = [CATextLayer]()
//
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        layer.needsDisplayOnBoundsChange = true
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//
//
//
//
//    func samplePie(center: CGPoint, radius: CGFloat){
//
//        let total = dataSet.reduce(0.0){ $0 + $1.sample }
//        let chartData = dataSet.map(){ ($0.sample/total,$0.colour) }
//
//        var currentAngle = CGFloat.pi
//        for data in chartData{
//            let delta = (data.0 * 360).radians()
//
//            let sector = UIBezierPath(circleSegmentCenter: center, radius: radius, startAngle: currentAngle, endAngle: currentAngle + delta)
//
//            let shapeLayer = CAShapeLayer()
//            shapeLayer.path = sector.cgPath
//            shapeLayer.fillColor = data.1.cgColor
//            shapeLayer.strokeColor = UIColor.white.cgColor
//
//            self.layer.addSublayer(shapeLayer)
//            shapeLayers.append(shapeLayer)
//
//
//            let arcCenterMidAngle = ((delta/2) + currentAngle)
//
//
//
//            let center = calculatePosition(angle: arcCenterMidAngle, p: center, offset: (radius * 1.3))
//            centers.append(center)
//
//            currentAngle += delta
//        }
//
//        let hole = UIBezierPath(ovalIn: .init(x: center.x - radius/2, y: center.y - radius/2, width: radius, height: radius))
//        let holeLayer = CAShapeLayer()
//        holeLayer.strokeColor = UIColor.systemBackground.withAlphaComponent(0.5).cgColor
//        holeLayer.lineWidth = 10
//        holeLayer.fillColor = UIColor.systemBackground.cgColor
//        holeLayer.path = hole.cgPath
//
//        self.layer.addSublayer(holeLayer)
//        shapeLayers.append(holeLayer)
//
//    }
//
//
//
//    override func draw(_ rect: CGRect) {
//
//
//        centers.removeAll()
//        for sublayer in shapeLayers{
//            sublayer.removeFromSuperlayer()
//        }
//
//        for layer in textLayers{
//            layer.removeFromSuperlayer()
//        }
//        shapeLayers.removeAll()
//        textLayers.removeAll()
//
//
//
//        samplePie(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius)
//
//        for x in 0..<dataSet.count{
//
//            let textLayer = CATextLayer()
//            textLayer.string = String(dataSet[x].sample)
//            textLayer.fontSize = 25
//
//            textLayer.foregroundColor = UIColor.label.cgColor
//
//            textLayer.alignmentMode = .center
//
//            let width = textLayer.preferredFrameSize().width
//            let height = textLayer.preferredFrameSize().height
//            textLayer.frame = .init(x: 0, y: 0, width: width, height: height)
//            textLayer.position = centers[x]
//
//            textLayers.append(textLayer)
//            layer.addSublayer(textLayer)
//
//
//        }
//
//
//
//    }
//
//
//
//
//
//    public func calculatePosition(angle: CGFloat, p: CGPoint, offset: CGFloat) -> CGPoint {
//        return CGPoint(x: p.x + offset * cos(angle), y: p.y + offset * sin(angle))
//    }
//
//}
//
//


class PieChartView: UIView{



    var dataSet = [(value: Double , colour: UIColor , label: String?)](){
        didSet{
            total = dataSet.reduce(0.0){$0 + $1.value}
            self.setNeedsDisplay()
        }
    }
    
    private var total: Double = 0.0
    
    var radius = 10.0{
        didSet{
            self.setNeedsDisplay()
        }
    }


    var centers = [CGPoint]()

    var shapeLayers = [CAShapeLayer]()

    var holeLayer = CAShapeLayer()


    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.needsDisplayOnBoundsChange = true

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }






    func samplePie(center: CGPoint, radius: CGFloat){

//        let total = dataSet.reduce(0.0){ $0 + $1.sample }
        let chartData = dataSet.map(){ ($0.value/total,$0.colour) }

        var currentAngle = CGFloat.pi 
        for data in chartData{
            let delta = (data.0 * 360).radians()

            let sector = UIBezierPath(circleSegmentCenter: center, radius: radius, startAngle: currentAngle, endAngle: currentAngle + delta)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = sector.cgPath
            shapeLayer.fillColor = data.1.cgColor
            shapeLayer.strokeColor = UIColor.systemBackground.cgColor

            self.layer.addSublayer(shapeLayer)
            shapeLayers.append(shapeLayer)


            let arcCenterMidAngle = ((delta/2) + currentAngle)
            


            let center = calculatePosition(angle: arcCenterMidAngle, p: center, offset: (radius * 1.25))
            centers.append(center)
            
            currentAngle += delta
            
            
            
        }

        let hole = UIBezierPath(ovalIn: .init(x: center.x - radius/2, y: center.y - radius/2, width: radius, height: radius))
        
        holeLayer.strokeColor = UIColor.systemBackground.withAlphaComponent(0.5).cgColor
        holeLayer.lineWidth = 10
        holeLayer.fillColor = UIColor.systemBackground.cgColor
        holeLayer.path = hole.cgPath

        self.layer.addSublayer(holeLayer)
//        shapeLayers.append(holeLayer)

    }



    override func draw(_ rect: CGRect) {
        
        
        centers.removeAll()
            for sublayer in shapeLayers{
                sublayer.removeFromSuperlayer()
            }

        for layer in textLayers{
            layer.removeFromSuperlayer()
        }
        shapeLayers.removeAll()
        textLayers.removeAll()



        samplePie(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius)
        
        for x in 0..<dataSet.count{
            
            guard (dataSet[x].value / total) * 100 >= 4 else{
                continue
            }
            
            let para = NSMutableParagraphStyle()
            para.alignment = .center
            
            let plainTextAttributes: [NSAttributedString.Key : Any] = [
                
                .font            : UIFont.systemFont(ofSize: 14, weight: .light),
                .foregroundColor : UIColor.label,
                .paragraphStyle  : para
            ]
            

            let textLayer = CATextLayer()
            textLayer.string = NSAttributedString(string: "\(String(dataSet[x].value)) \n \(dataSet[x].label ?? "")", attributes: plainTextAttributes)
            textLayer.fontSize = 10
//            textLayer.backgroundColor = UIColor.black.cgColor
            textLayer.foregroundColor = UIColor.label.cgColor
            
            
            textLayer.alignmentMode = .center
            
            let width = textLayer.preferredFrameSize().width
            let height = textLayer.preferredFrameSize().height
            textLayer.frame = .init(x: 0, y: 0, width: width, height: height)
            textLayer.position = centers[x]
            textLayer.contentsScale = window?.windowScene?.screen.scale ?? 1
//            textLayer.allowsFontSubpixelQuantization = true
            
            
            textLayers.append(textLayer)
            layer.addSublayer(textLayer)
            
           

            

        }



    }

    var textLayers = [CATextLayer]()


    override func layoutSubviews() {
        super.layoutSubviews()

    }


    public func calculatePosition(angle: CGFloat, p: CGPoint, offset: CGFloat) -> CGPoint {
        return CGPoint(x: p.x + offset * cos(angle), y: p.y + offset * sin(angle))
    }
    
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        if let touch = touches.first{
//            for layer in shapeLayers {
//                if layer.path!.contains(touch.location(in: self)) && !(holeLayer.path!.contains(touch.location(in: self))){
//                    if let index = shapeLayers.firstIndex(of: layer){
//                         let textlayer = textLayers[index]
//                        textlayer.position = offsetPointRadially(from: CGPoint(x: bounds.midX, y: bounds.midY), to: textlayer.position, distance: 40)
//
//
//                    }
//                }else{
////                    print(touch.location(in: self))
//                }
//            }
//        }
//
//    }
    
    func offsetPointRadially(from startPoint: CGPoint, to endPoint: CGPoint, distance: CGFloat) -> CGPoint {
        let angle = atan2(endPoint.y - startPoint.y, endPoint.x - startPoint.x)
        let x = endPoint.x + cos(angle) * distance
        let y = endPoint.y + sin(angle) * distance
        return CGPoint(x: x, y: y)
    }

    
}
