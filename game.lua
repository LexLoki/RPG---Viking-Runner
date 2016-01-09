require "stage"
require "player"
require "enemy"
require "bullet"
require "animations"

game = {}
game.isPaused = false

function game.load()
  game.pauseImg = love.graphics.newImage("/Assets/Tela_Intro/Pause.png")
  stage.load()
  player.load()
  enemies.load()
  bullet.load()
  game.startTime = 2
  game.startAnim = animComp.newAnim(12,player.sprites[run].time)
  animations.load()
end

function game.keypressed(key)
  if key=="escape" or key=="return" then
    game.isPaused = not game.isPaused
  elseif not game.isPaused and not(game.startTime>0) then
    player.keypressed(key)
  end
end

function game.mousepressed(x,y,button)
end

function game.update(dt)
  if not game.isPaused then
    stage.update(dt)
    if game.startTime>0 then game.startUpdate(dt) else       player.update(dt) end
    enemies.update(dt)
    bullet.update(dt)
    animations.update(dt)
  end
end

function game.draw()
  stage.draw()
  if game.startTime>0 then game.startDraw() else player.draw() end
  enemies.draw()
  bullet.draw()
  animations.draw()
  game.pauseDraw()
end

function game.startUpdate(dt)
  game.startTime = game.startTime-dt
  if game.startTime<0 then
    game.startTime = 0
    game.start()
  end
  player.x = -player.imgWidth+(1-game.startTime/2)*2*player.imgHeight
  animComp.update(dt,game.startAnim)
end

function game.startDraw()
  local sprite = player.sprites[run]
  love.graphics.draw(sprite.sheet, sprite.quads[game.startAnim.curr_frame],player.x,player.y,0,player.scale,player.scale,player.offset.x,player.offset.y)
  shield.draw()
  game.pauseDraw()
end

function game.prepareBackgrounds(data)
  stage.prepareBackgrounds(data)
  player.x = -player.width
end

function game.startAnimation()
end

function game.start()
  stage.start()
end

function game.pauseDraw()
  if game.isPaused then
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    love.graphics.setColor(0,0,0,100)
    love.graphics.rectangle("fill",0,0,w,h)
    love.graphics.setColor(255,255,255)
    love.graphics.draw(game.pauseImg,0,0,0,w/game.pauseImg:getWidth(),h/game.pauseImg:getHeight())
  end
end