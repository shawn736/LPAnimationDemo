//
//  PointTransformViewController.swift
//  LPAnimationDemo
//
//  Created by Shawn on 2018/11/21.
//  Copyright © 2018 fcs. All rights reserved.
//

import UIKit

/*
 已知（x1, y1）, (x2, y2), 直线表达式是Ax + By + C = 0
 1.两点的直线
 A=y2-y1
 B=x1-x2
 C=x2*y1-x1*y2
 
 2.距离为T的两条平行线
 Ap = A
 Bp = B
 Cp = C ± T * sqrt(A^2 + B^2)
 
 3.中垂线
 A = 2*(x2-x1)
 B = 2*(y2-y1)
 C = x1^2-x2^2+y1^2-y2^2
 
 4.中垂线和两条平行线的交点
 二条直线：A1X+B1Y+C1=0与A2X+B2Y+C2=0,他们焦点是（x,y）
 m=A1*B2-A2*B1
 x=(C2*B1-C1*B2)/m
 y=(C1*A2-C2*A1)/m
 */

class PointTransformViewController: UIViewController {
  
  let view01 = UIView(frame: CGRect(x: 100, y: 200, width: 50, height: 50))
  let view02 =  UIView(frame: CGRect(x: 200, y: 400, width: 50, height: 50))
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    view01.backgroundColor = UIColor.yellow
    view02.backgroundColor = UIColor.yellow
    view.addSubview(view01)
    view.addSubview(view02)
    
    let one = view01.center
    let two = view02.center
    let line = self.line(one: one, two: two)
    let dt: CGFloat = 50
    let pallesLines = self.pallelLines(line: line, dt: dt)
    let vercalLine = self.verticalLine(one: one, two: two)
    let pointOne = self.pointWithVerticalLineAndPallelLine(one: pallesLines[0], two: vercalLine)
    let pointTwo = self.pointWithVerticalLineAndPallelLine(one: pallesLines[1], two: vercalLine)
    
    let viewOne = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    viewOne.center = pointOne
    viewOne.backgroundColor = .blue
    view.addSubview(viewOne)
    
    let viewTwo = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    viewTwo.center = pointTwo
    viewTwo.backgroundColor = .blue
    view.addSubview(viewTwo)
  }
  
  func line(one: CGPoint, two: CGPoint) -> (CGFloat, CGFloat, CGFloat) {
    let A = two.y - one.y
    let B = one.x - two.x
    let C = two.x * one.y - one.x * two.y
    return (A, B, C)
  }
  
  func pallelLines(line: (CGFloat, CGFloat, CGFloat), dt: CGFloat) -> [(CGFloat, CGFloat, CGFloat)] {
    let A = line.0
    let B = line.1
    let tmp:CGFloat = dt * sqrt(line.0 * line.0 + line.1 * line.1)
    return [(A, B, line.2 + tmp), (A, B, line.2 - tmp)]
  }
  
  func verticalLine(one: CGPoint, two: CGPoint) -> (CGFloat, CGFloat, CGFloat) {
    let A = 2.0 * (two.x - one.x)
    let B = 2.0 * (two.y - one.y)
    let C = one.x * one.x - two.x * two.x + one.y * one.y -  two.y * two.y
    return (A, B , C)
  }
  
  func pointWithVerticalLineAndPallelLine(one: (CGFloat, CGFloat, CGFloat), two: (CGFloat, CGFloat, CGFloat)) -> CGPoint {
    let m = one.0 * two.1 - two.0 * one.1
    let x = (two.2*one.1 - one.2*two.1)/m
    let y = (one.2*two.0 - two.2*one.0)/m
    return CGPoint(x: x, y: y)
  }

}
