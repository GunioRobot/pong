function love.load()
    playing = false
    altPressed = false
    score = {}
    score.left = 0
    score.right = 0

    world = love.physics.newWorld(800, 600)
    world:setCallbacks(collision, nil, nil, nil)

    leftWall = {}
    leftWall.body = love.physics.newBody(world, 0, 300)
    leftWall.shape = love.physics.newRectangleShape(leftWall.body, 0, 0, 5, 600)
    leftWall.shape:setData("left")
    leftWall.shape:setFriction(0)
    
    rightWall = {}
    rightWall.body = love.physics.newBody(world, 800, 300)
    rightWall.shape = love.physics.newRectangleShape(rightWall.body, 0, 0, 5,
        600)
    rightWall.shape:setData("right")
    rightWall.shape:setFriction(0)
    
    roof = {}
    roof.body = love.physics.newBody(world, 400, 0)
    roof.shape = love.physics.newRectangleShape(roof.body, 0, 0, 800, 5)
    roof.shape:setFriction(0)
    
    floor = {}
    floor.body = love.physics.newBody(world, 400, 600)
    floor.shape = love.physics.newRectangleShape(floor.body, 0, 0, 800, 5)
    floor.shape:setFriction(0)

    ball = {}
    ball.radius = 5
    ball.body = love.physics.newBody(world, 0, 300, 1, 0)
    ball.shape = love.physics.newCircleShape(ball.body, 0, 0, ball.radius)
    ball.shape:setRestitution(1)
    ball.image = love.graphics.newImage("images/ball.png")

    paddleHeight = 100
    paddleWidth = 10
    paddleForce = 100000
    paddleCenter = 250

    leftPaddle = {}
    leftPaddle.body = love.physics.newBody(world, leftPaddle.x, paddleCenter, 10000, 0)
    leftPaddle.shape = love.physics.newRectangleShape(leftPaddle.body, 5, 50,
        paddleWidth, paddleHeight)
    leftPaddle.x = 20
    leftPaddle.image = love.graphics.newImage("images/leftPaddle.png")

    rightPaddle = {}
    rightPaddle.body = love.physics.newBody(world, rightPaddle.x, paddleCenter, 10000, 0)
    rightPaddle.shape = love.physics.newRectangleShape(rightPaddle.body, 5, 50,
        paddleWidth, paddleHeight)
    rightPaddle.x = 770
    rightPaddle.image = love.graphics.newImage("images/rightPaddle.png")

    -- pseudo-random decision of the starter
    starter = "left"
    if (os.time() % 2 == 1) then
        reset("left")
    else
        reset("right")
    end
end

local function leftPlayer()
    local isDown = love.keyboard.isDown
       
    if isDown("s") then
        leftPaddle.body:applyForce(0, paddleForce, 0, 0)
    elseif isDown("w") then
        leftPaddle.body:applyForce(0, -paddleForce, 0, 0)
    end

    leftPaddle.body:setPosition(leftPaddle.x, leftPaddle.body:getY())
    if playing == false and starter == "left" then
        ball.body:setY(leftPaddle.body:getY() + 45)
    end
end

local function rightPlayer()
    local isDown = love.keyboard.isDown

    if isDown("down") then
        rightPaddle.body:applyForce(0, paddleForce, 0, 0)
    elseif isDown("up") then
        rightPaddle.body:applyForce(0, -paddleForce, 0, 0)
    end

    rightPaddle.body:setPosition(rightPaddle.x, rightPaddle.body:getY())
    if playing == false and starter == "right" then
        ball.body:setY(rightPaddle.body:getY() + 45)
    end
end

function collision(a)
    if a == "left" then
        score.right = score.right + 1
        reset("left")
    elseif a == "right" then
        score.left = score.left + 1
        reset("right")
    end
end

function reset(side)
    playing = false
    ball.body:setLinearVelocity(0, 0)
    if side == "left" then
        ball.body:setPosition(35, 295)
        leftPaddle.body:setLinearVelocity(0, 0)
        leftPaddle.body:setPosition(leftPaddle.x, paddleCenter)
    else
        ball.body:setPosition(755, 295)
        rightPaddle.body:setLinearVelocity(0, 0)
        rightPaddle.body:setPosition(rightPaddle.x, paddleCenter)
    end
    starter = side
end
    
function love.update(dt)
    leftPlayer()
    rightPlayer()

    world:update(dt)
end

function love.draw()
    love.graphics.draw(ball.image, ball.body:getX(), ball.body:getY())
    love.graphics.draw(leftPaddle.image, leftPaddle.body:getX(), 
        leftPaddle.body:getY())
    love.graphics.draw(rightPaddle.image, rightPaddle.body:getX(),
        rightPaddle.body:getY())
    love.graphics.print(score.left .. " - " .. score.right, 400, 300)
end

function love.keypressed(k)
    if k == " " and playing == false then
        playing = true
        if starter == "left" then
            ball.body:applyImpulse(-20, 0, 0, 0)
        else
            ball.body:applyImpulse(20, 0, 0, 0)
        end
    end
    
    if k == "lalt" then
        altPressed = true
    end

    if k == "q" or k == "escape" or (altHit and k == "f4") then
        love.event.push("q")
    end
end

function love.keyreleased(k)
    if k == "lalt" then
        altPressed = false
    end
end
