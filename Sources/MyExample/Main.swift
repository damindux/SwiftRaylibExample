import Raylib

let Black = Color(r: 0, g: 0, b: 0, a: 255)
let White = Color(r: 255, g: 255, b: 255, a: 255)

let ScreenWidth: Int32 = 800
let ScreenHeight: Int32 = 600

InitWindow(ScreenWidth, ScreenHeight, "Hello from Swift")
SetTargetFPS(60)
defer { CloseWindow() }

let keyW = Int32(KEY_W.rawValue)
let keyS = Int32(KEY_S.rawValue)
let keyUp = Int32(KEY_UP.rawValue)
let keyDown = Int32(KEY_DOWN.rawValue)
let keySpace = Int32(KEY_SPACE.rawValue)

struct Player {
	let xPosition: Int32
	var yPosition: Int32
	var score = 0
}

struct Ball {
	var x: Int32
	var y: Int32

	let radius: Int32 = 10

	var velocityX: Int32 = 0
	var velocityY: Int32 = 0

	var launched = false
}

@MainActor
func updatePlayers()
{
	if IsKeyDown(keyW) { player1.yPosition -= 10 }
	if IsKeyDown(keyS) { player1.yPosition += 10 }

	if IsKeyDown(keyUp) { player2.yPosition -= 10 }
	if IsKeyDown(keyDown) { player2.yPosition += 10 }

	player1.yPosition = max(0, min(player1.yPosition, ScreenHeight - 100))
	player2.yPosition = max(0, min(player2.yPosition, ScreenHeight - 100))

	guard !ball.launched else { return }
	if IsKeyDown(keySpace) { 
		ball.launched = true

		ball.velocityX  = Bool.random() ? 6 : -6

		repeat {
			ball.velocityY = GetRandomValue(-8, 8) 
		} while ball.velocityY == 0
	}
}

@MainActor
func updateBall()
{
	guard ball.launched else { return }

	if ball.y - ball.radius <= 0 || ball.y + ball.radius >= ScreenHeight { 
		ball.velocityY = -ball.velocityY 
	}	

	ball.x += ball.velocityX
	ball.y += ball.velocityY
}

@MainActor
func checkCollision()
{
	if ball.x - ball.radius <= player1.xPosition + 10 &&
	   ball.y >= player1.yPosition &&
	   ball.y <= player1.yPosition + 100 &&
	   ball.velocityX < 0
	{
	    ball.velocityX = -ball.velocityX
	}

	if ball.x + ball.radius >= player2.xPosition &&
	   ball.y >= player2.yPosition &&
	   ball.y <= player2.yPosition + 100 &&
	   ball.velocityX > 0
	{
	    ball.velocityX = -ball.velocityX
	}
}

@MainActor
func checkBall()
{
	if ball.x < 0 { 
		player2.score += 1
		resetBall() 
	}

	if ball.x > ScreenWidth { 
		player1.score += 1
		resetBall()
	}
}

@MainActor
func resetBall() {
    ball.x = ScreenWidth / 2
    ball.y = ScreenHeight / 2
    ball.velocityX = 0
    ball.velocityY = 0
    ball.launched = false
}

var player1 = Player(xPosition: 10, yPosition: (ScreenHeight / 2) - 50)
var player2 = Player(xPosition: ScreenWidth - 20, yPosition: (ScreenHeight / 2) - 50)

var ball = Ball(x: ScreenWidth / 2, y: ScreenHeight / 2)

while !WindowShouldClose() {
	checkBall()
	updateBall()
	updatePlayers()
	checkCollision()

	BeginDrawing()
	ClearBackground(Black)

	DrawRectangle(player1.xPosition, player1.yPosition, 10, 100, White)
	DrawRectangle(player2.xPosition, player2.yPosition, 10, 100, White)

	var y: Int32 = 0
	while y < ScreenHeight {
        DrawRectangle((ScreenWidth / 2) - 2, y, 4, 20, White)
        y += 35
    }

	DrawText("\(player1.score)", 200, 10, 36, White)
	DrawText("\(player2.score)", 600, 10, 36, White)

	DrawCircle(ball.x, ball.y, Float(ball.radius), White)

	EndDrawing()
}
