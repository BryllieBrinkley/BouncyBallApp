import Foundation

let ball = OvalShape(width: 40, height: 40)

var barriers: [Shape] = []
var targets: [Shape] = []

let funnelPoints = [
    Point(x: 0, y: 50),
    Point(x: 80, y: 50),
    Point(x: 60, y: 0),
    Point(x: 20, y: 0)
]

let funnel = PolygonShape(points: funnelPoints)

fileprivate func setupBall() {
    ball.position = Point(x: 250, y: 400)
    scene.add(ball)
    ball.hasPhysics = true
    ball.fillColor = .red
    ball.isDraggable = false
    ball.bounciness = 0.6
    ball.onCollision = ballCollided(with:)
    
    scene.trackShape(ball)
    ball.onExitedScene = ballExitedScene
    ball.onTapped = resetGame
}

fileprivate func addBarrier(at position: Point, width: Double, height: Double, angle: Double ) {
    
    let barrierPoints = [
        Point(x: 0, y: 0),
        Point(x: 0, y: height),
        Point(x: width, y: height),
        Point(x: width, y: 0)
    ]
    
    let barrier = PolygonShape(points: barrierPoints)
    
    barriers.append(barrier)
    
    barrier.position = position
    barrier.hasPhysics = true
    scene.add(barrier)
    barrier.isImmobile = true
    barrier.fillColor = .blue
    barrier.angle = angle
}

fileprivate func setupFunnel() {
    funnel.position = Point(x: 200, y: scene.height - 25)
    scene.add(funnel)
    funnel.fillColor = .lightGray
    funnel.isDraggable = false
}

func addTarget(at position: Point) {
    let targetPoints = [
        Point(x: 10, y: 0),
        Point(x: 0, y: 10),
        Point(x: 10, y: 20),
        Point(x: 20, y: 10)
    ]
    
    let target = PolygonShape(points: targetPoints)
    
    targets.append(target)
    
    target.position = position
    target.hasPhysics = true
    target.isImmobile = true
    target.isImpermeable = true
    target.isDraggable = false
    target.fillColor = .yellow
    target.name = "target"
    scene.add(target)
}

func setup() {
    
    setupBall()
    
    addBarrier(at: Point(x: 200, y: 150), width: 80, height: 25, angle: 0.1)
    
    setupFunnel()
    
    addTarget(at: Point(x: 150, y: 400))
    
    funnel.onTapped = dropBall
    
    scene.onShapeMoved = printPosition(of:)
    
    resetGame()
}


func dropBall() {
    ball.position = funnel.position
    ball.stopAllMotion()
    
    for barrier in barriers {
        barrier.isDraggable = false
    }
}

func ballCollided(with otherShape: Shape) {
    if otherShape.name != "target" { return }
    otherShape.fillColor = .green
}

func ballExitedScene() {
    
    for barrier in barriers {
        barrier.isDraggable = true
    }
}

func resetGame() {
    ball.position = Point(x: 0, y: -80)
}

func printPosition(of shape: Shape) {
    print(shape.position)
}
