
function love.load()
    myFont = love.graphics.newFont("res/nsecthin.ttf", 50)
    gameState = "menu"
    createPlayer()
    createObstacles()
end

function love.update(dt)
    if gameState == "menu" then
        updateMenu()
    elseif gameState == "play" then
        updatePlayerMovement(dt, player)
        updateObstacles(dt)

        -- Verificar colisiones y perder vidas
        for i, obs in ipairs(obstacles) do
            if checkCollision(player, obs) and not obs.isDestroyed then
                player.lives = player.lives - 1
                print("Player Lives: " .. player.lives)
                obs.isDestroyed = true
                if player.lives <= 0 then
                    gameState = "gameover"
                end
            end
        end

        if love.keyboard.isDown("escape") then
            gameState = "gameover"
        end

    elseif gameState == "credits" then
        if love.keyboard.isDown("space") then
            gameState = "menu"
        end
    elseif gameState == "gameover" then
        updateGameOver()
    end
end

function love.draw()
    love.graphics.setFont(myFont)
    if gameState == "menu" then
        drawMenu()
    elseif gameState == "play" then
        drawHUD()
        drawPlayer()
    
        -- Dibujar obstáculos
        for i, obs in ipairs(obstacles) do
            -- "Gizmo" to see collision boundries
            --love.graphics.rectangle("fill", obs.x, obs.y, obs.width, obs.height)
            love.graphics.draw(obs.image, obs.x, obs.y)
        end
    elseif gameState == "credits" then
        drawCredits()
    elseif gameState == "gameover" then
        drawGameOver()
    end
end

-- Crear el jugador
function createPlayer()
    player = {}
    player.posX = love.graphics.getWidth() / 2
    player.posY = (love.graphics.getHeight() / 5) * 4 
    player.speed = 400
    player.height = 75
    player.width = 30
    player.lives = 3
    player.score = 0
    player.image = love.graphics.newImage("res/love_car.png")
end

-- Crear los obstáculos
function createObstacles()
    obstacles = {}
    for i = 1, 5 do
        table.insert(obstacles, 
        {
            x = math.random(0, love.graphics.getWidth() - 50),
            y = math.random(-200, -50),
            width = 50,
            height = 50,
            speed = math.random(200, 400),
            isDestroyed = false,
            image = love.graphics.newImage("res/love_crate.png")
        })
    end
end

-- Actualizar movimiento de obstáculos
function updateObstacles(dt)
    for i, obs in ipairs(obstacles) do
        obs.y = obs.y + obs.speed * dt

        -- Resetear obstáculo si sale de la pantalla
        if obs.y > love.graphics.getHeight() then
            obs.y = math.random(-200, -50)
            obs.x = math.random(0, love.graphics.getWidth() - obs.width)
            obs.isDestroyed = false
            player.score = player.score + 1
        end
    end
end

-- Actualizar movimiento del jugador
function updatePlayerMovement(deltaTime, player)
    margin = 5

    if love.keyboard.isDown("w") and player.posY > margin then
        player.posY = player.posY - player.speed * deltaTime
    end
    if love.keyboard.isDown("a") and player.posX > margin then
        player.posX = player.posX - player.speed * deltaTime
    end
    if love.keyboard.isDown("s") and player.posY + player.height < (love.graphics.getHeight() - margin) then
        player.posY = player.posY + player.speed * deltaTime
    end
    if love.keyboard.isDown("d") and player.posX + player.width < (love.graphics.getWidth() - margin) then
        player.posX = player.posX + player.speed * deltaTime
    end
end

function checkCollision(playerObj, obstacleObj)
    return playerObj.posX < obstacleObj.x + obstacleObj.width and
           playerObj.posX + playerObj.width > obstacleObj.x and
           playerObj.posY < obstacleObj.y + obstacleObj.height and
           playerObj.posY + playerObj.height > obstacleObj.y
end

function drawMenu()
    screenPortion = love.graphics.getHeight() / 8
    love.graphics.setColor(1, 0.733, 0, 1)
    love.graphics.printf("BOX AVOIDER", 0, screenPortion, love.graphics.getWidth(), "center")
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Move with WASD and survive to get higher score!", 0.5, screenPortion*3, love.graphics.getWidth(), "center")
    love.graphics.printf("1. Play", 0, screenPortion*5, love.graphics.getWidth(), "center")
    love.graphics.printf("2. Credits", 0, screenPortion*6, love.graphics.getWidth(), "center")
    love.graphics.printf("3. Exit", 0, screenPortion*7, love.graphics.getWidth(), "center")
end

function updateMenu()
    if love.keyboard.isDown("1") then
        gameState = "play"
        print("Game State: Play")
    elseif love.keyboard.isDown("2") then
        gameState = "credits"
        print("Game State: Credits")
    elseif love.keyboard.isDown("3") then
        love.event.quit()
    end
end

function updateGameOver()
    if love.keyboard.isDown("space") then
        gameState = "menu"
        player.lives = 3
        player.score = 0
        createObstacles()
        print("Game State: Menu")
    end
end

function drawGameOver()
    love.graphics.printf("Game Over!", 0, 200, love.graphics.getWidth(), "center")
    love.graphics.printf("Score: " .. (player.score or 0), 0, 300, love.graphics.getWidth(), "center")
    love.graphics.printf("Press Space to go back to Menu", 0, 400, love.graphics.getWidth(), "center")
end

function drawHUD()
    love.graphics.print("Lives: " .. player.lives, 10, 10)
    love.graphics.print("Score: " .. math.floor(player.score), love.graphics.getWidth() - 400, 10)
end

function drawPlayer()
    playerSpriteMargin = 10
    love.graphics.draw(player.image, player.posX-player.width, player.posY - playerSpriteMargin, 0, 1.5, 1.5)
    -- "Gizmo" to see collision boundries
    --love.graphics.rectangle("line", player.posX, player.posY, player.width, player.height)
end

function drawCredits()
    screenPortion = love.graphics.getHeight() / 8

    love.graphics.setColor(1, 0.733, 0, 1)
    love.graphics.printf("Credits", 0, screenPortion, love.graphics.getWidth(), "center")
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf("<< TP Bonus LOVE >>", 0, screenPortion*2, love.graphics.getWidth(), "center")
    love.graphics.printf("Tomas Francisco Luchelli", 0, screenPortion*3, love.graphics.getWidth(), "center")
    love.graphics.printf("Practica Profesional 1:", 0, screenPortion*4, love.graphics.getWidth(), "center") 
    love.graphics.printf("Desarrollo de Videojuegos 1", 0, screenPortion*5, love.graphics.getWidth(), "center")
    love.graphics.printf("Press SPACE to go back", 0, screenPortion*6, love.graphics.getWidth(), "center")
end
