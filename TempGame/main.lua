
function love.load()
    createPlayer()
    createObstacles()
end

function love.update(dt)
    updatePlayerMovement(dt, player)
    updateObstacles(dt)

    -- Verificar colisiones del jugador con todos los obstáculos
    for i, obs in ipairs(obstacles) do
        if checkCollision(player, obs) and obs.isDestroyed == false then
            player.lives = player.lives - 1
            print("Player Lives: " .. player.lives)
            obs.isDestroyed = true
        end
    end

end

function love.draw()
    -- Dibujar jugador
    love.graphics.setColor(0.522, 0.914, 1, 1)
    love.graphics.rectangle("line", player.posX, player.posY, player.width, player.height)
    love.graphics.setColor(1,1,1,1)
    
    -- Dibujar obstáculos
    for i, obs in ipairs(obstacles) do
        love.graphics.rectangle("fill", obs.x, obs.y, obs.width, obs.height)
    end

    -- Debug para el punto de anclaje del jugador
    love.graphics.setColor(1,0,0,1)
    love.graphics.circle("fill", player.posX, player.posY, 10)
    love.graphics.setColor(1,1,1,1)
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
            isDestroyed = false
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

-- Función de colisiones AABB
function checkCollision(playerObj, obstacleObj)
    return playerObj.posX < obstacleObj.x + obstacleObj.width and
           playerObj.posX + playerObj.width > obstacleObj.x and
           playerObj.posY < obstacleObj.y + obstacleObj.height and
           playerObj.posY + playerObj.height > obstacleObj.y
end