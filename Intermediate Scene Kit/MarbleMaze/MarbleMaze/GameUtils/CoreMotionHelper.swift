  /*
   * Copyright (c) 2015 Razeware LLC
   *
   * Permission is hereby granted, free of charge, to any person obtaining a copy
   * of this software and associated documentation files (the "Software"), to deal
   * in the Software without restriction, including without limitation the rights
   * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   * copies of the Software, and to permit persons to whom the Software is
   * furnished to do so, subject to the following conditions:
   *
   * The above copyright notice and this permission notice shall be included in
   * all copies or substantial portions of the Software.
   *
   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   * THE SOFTWARE.
   */
  
  import Foundation
  import CoreMotion
  
  class CoreMotionHelper {
    
    let motionManager = CMMotionManager()
    
    init() {
    }
    
    func getAccelerometerData(_ interval: TimeInterval = 0.1,
                              closure: ((_ x: Float, _ y: Float, _ z: Float) -> ())? ){
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = interval
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                guard let data = data else {return}
                let x = Float(data.acceleration.x)
                let y = Float(data.acceleration.y)
                let z = Float(data.acceleration.z)
                if let closure = closure {
                closure(x,y,z)
                }
            }
        }
    }
}
