


function love.load()
    createPlayer()
    
end

function love.update(dt)
    if love.keyboard.isDown("right") then
        player.posX = player.posX + player.speed * dt
    end
    if love.keyboard.isDown("left") then
        player.posX = player.posX - player.speed * dt
    end
    if love.keyboard.isDown("down") then
        player.posY = player.posY + player.speed * dt
    end
    if love.keyboard.isDown("up") then
        player.posY = player.posY - player.speed * dt
    end
end

function love.draw()
    love.graphics.print("BOKITA", 400, 300)
    love.graphics.rectangle("line", player.posX, player.posY, player.width, player.height)
    
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