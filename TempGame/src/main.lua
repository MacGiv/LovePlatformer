


function love.load()
    createPlayer()
    
end

function love.update(dt)
    updatePlayerMovement(dt, player)

end

function love.draw()
    love.graphics.print("BOKITA", 400, 300)
    love.graphics.rectangle("line", player.posX, player.posY, player.width, player.height)
    
    --Debug for anchor point
    love.graphics.setColor(1,0,0,1)
    love.graphics.circle("fill", player.posX, player.posY, 10)
    love.graphics.setColor(1,1,1,1)
    --Debug for anchor point end
end

function createPlayer()
    player = {}
    player.posX = 0
    player.posY = 0
    player.speed = 400
    player.height = 100
    player.width = 50
    --player.image = love.graphics.newImage("res/Legacy_Fantasy_High_Forest/Character/Idle/Idle.gif")
end

function updatePlayerMovement(deltaTime, player)
    if love.keyboard.isDown("w") then
        player.posY = player.posY - player.speed * deltaTime
    end
    if love.keyboard.isDown("a") then
        player.posX = player.posX - player.speed * deltaTime
    end
    if love.keyboard.isDown("s") then
        player.posY = player.posY + player.speed * deltaTime
    end
    if love.keyboard.isDown("d") then
        player.posX = player.posX + player.speed * deltaTime
    end
end