local pd <const> = playdate
local gfx <const> = pd.graphics

import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/crank'
--eyes
eyesImageFolder = {}
amountOfEyeImage = #pd.file.listFiles("images/eyes")
for eyeImageImport = 1, amountOfEyeImage do
    eyesImageFolder[eyeImageImport] = gfx.image.new("images/eyes/eye"..eyeImageImport)
end

print(amountOfEyeImage)
--noses
noseImageFolder = {}
amountOfNoseImage = #pd.file.listFiles("images/noses")
for noseImageImport = 1, amountOfNoseImage do
    noseImageFolder[noseImageImport] = gfx.image.new("images/noses/nose"..noseImageImport)
end
print(amountOfNoseImage)
--
pd.setCrankSoundsDisabled(true)

--where things are
headX = 200
headY = 100
--
shirtX = 200
shirtY = 120
--
footYChange = 0
--variables that are made once
head = 1
shirt = 1
headPositionOrigin = {headX, headY}
footPosition1 = {headX, 0}
footPosition2 = {headX, 0}
lineSize = 3
footSliding1 = false
footSliding2 = false
headDiameter = (lineSize*5)

eye1 = playdate.graphics.sprite.new()
eye1:add()
eye1:moveTo(headX+headDiameter/4.5
, headY-headDiameter/4)
eye1:setImage(eyesImageFolder[1])

eye2 = playdate.graphics.sprite.new()
eye2:add()
eye2:moveTo(headX-headDiameter/4.5, headY-headDiameter/4)
eye2:setImage(eyesImageFolder[1]) 

nose1 = playdate.graphics.sprite.new()
nose1:add()
nose1:moveTo(headX-headDiameter/4.5, headY-headDiameter/4)
nose1:setImage(noseImageFolder[1], 1)
--

local headImage = gfx.image.new(headDiameter*2, headDiameter*2)
gfx.pushContext(headImage)
  gfx.drawCircleInRect(0, 0, headDiameter*2, headDiameter*2)
gfx.popContext()

local head1 = gfx.sprite.new()
head1:moveTo(200, 120)
head1:setImage(headImage)
head1:add()

--
function headMoveBy(x, y)
    headX+=x
    headY+=y
end
function shirtMoveBy(x, y)
    shirtX+=x
    shirtY+=y
end

--main loop
function pd.update()
    gfx.clear()
    gfx.sprite.update()
    pd.timer.updateTimers()
    pd.drawFPS(0, 228)
    --crank will update 7 times in one rotation
    crankTicks = pd.getCrankTicks(7)
    --setting variables updated every loop

    scaledHeadShirtMovement = (1.4/3)*lineSize
    --diameter of the head
    headDiameter = (lineSize*5)
    --middle of head
    headPosition = {headX, headY}
    --position of neck (middle bottom of head)
    neckPosition = {
        headPosition[1],
        headPosition[2]+headDiameter
    }
    --position of shirt (middle bottom)
    shirtBottom = {
        headPositionOrigin[1]+shirtX-200,
        (headPositionOrigin[2]+headDiameter*3.5)+shirtY-120
    }
    --distance between shirt (middle bottom of shirt) and head
    headShirtDistance = {
    headPosition[1]-shirtBottom[1]+((headDiameter*1.5)+(headDiameter*-1.5)),
    headPosition[2]-shirtBottom[2]}
    --distance between foot 1 and head
    headFootDistance1 = {
    headPosition[1]-footPosition1[1],
    headPosition[2]-footPosition1[2]}
    --distance between foot 2 and head
    headFootDistance2 = {
    headPosition[1]-footPosition2[1],
    headPosition[2]-footPosition2[2]}
    
    gfx.setLineWidth(lineSize)

    --making things 

    --shirt
    gfx.drawLine(
        --point A
        neckPosition[1]+headDiameter/2,
        neckPosition[2]-headDiameter*0.1,
        --point B
        shirtBottom[1]+headDiameter*1.5,
        shirtBottom[2]
    )
    gfx.drawLine(
        neckPosition[1]+headDiameter/2*-1,
        neckPosition[2]-headDiameter*0.1,

        shirtBottom[1]+headDiameter*-1.5,
        shirtBottom[2]
    )
    gfx.drawLine(
        shirtBottom[1]+headDiameter*1.5,
        shirtBottom[2],

        shirtBottom[1]+headDiameter*-1.5,
        shirtBottom[2]
    )
    --legs
    gfx.drawLine(
        shirtBottom[1]+headDiameter/4,
        shirtBottom[2],

        footPosition1[1]+headDiameter/3,
        (shirtBottom[2]+20*lineSize)+footYChange
    )
    gfx.drawLine(
        shirtBottom[1]-headDiameter/4,
        shirtBottom[2],

        footPosition2[1]-headDiameter/3,
        (shirtBottom[2]+20*lineSize)+footYChange
    )
    --sprite updates
    eye1:setScale(lineSize/19)
    eye1:moveTo(headPosition[1]+headDiameter/4.5, headPosition[2]-(headDiameter/3.5)+headDiameter/5)

    eye2:setScale(lineSize/21)
    eye2:moveTo(headPosition[1]-headDiameter/4.5, headPosition[2]-headDiameter/3.5)

    nose1:setScale(lineSize/15)
    nose1:moveTo(headPosition[1]-headDiameter, headPosition[2]+headDiameter/3)
    nose1:setImage(noseImageFolder[1], 1)
    nose1:setZIndex(10)
    --making it so head scales every frame =O
    headImage = gfx.image.new(headDiameter*3, headDiameter*3)
    gfx.pushContext(headImage)
        gfx.drawCircleInRect(lineSize, lineSize, (headDiameter*2), (headDiameter*2))
    gfx.popContext()
    head1:setImage(headImage)
    head1:moveTo(headPosition[1]+headDiameter/3, headPosition[2]+headDiameter/3)
    --the leg resets 
    if headPosition[1]>= shirtBottom[1]then
        if footPosition1[1] <= shirtBottom[1] then
            footSliding1 = false
        end
    else
        if footPosition1[1] >= shirtBottom[1] then
            footSliding1 = false
        end
    end
    --the leg resets other foot
    if headPosition[1]>= shirtBottom[1]then
        if footSliding1 == true then
            if footPosition2[1] <= shirtBottom[1] then
                footSliding2 = false
            end
        end
    else
        if footSliding1 == true then
            if footPosition2[1] >= shirtBottom[1] then
                footSliding2 = false
            end
        end
    end
    if math.abs(headFootDistance1[1]) >= 8.5*lineSize then
        if footSliding1 == false then
            footPosition1[1] = headPosition[1]
            footSliding1 = true
        end
    end
    --waits until the first foot has slid back a bit before moving the second forward
    if math.abs(headFootDistance1[1]) >= 3.5*lineSize then
        if footSliding2 == false then
            footPosition2[1] = headPosition[1]+(scaledHeadShirtMovement/3)
            footSliding2 = true
        end
    end
    --movement
    if pd.buttonIsPressed(pd.kButtonUp) then
        headY-=scaledHeadShirtMovement
        --moves the shirt and feet with a delay to the head
        if headShirtDistance[2] <= -18.6*lineSize then
            --moves feet with delay too shirt
            if footYChange <= 0 then
                footYChange+=(1/3)*lineSize
            end
            shirtY-=scaledHeadShirtMovement
        end
    end
    if pd.buttonIsPressed(pd.kButtonDown) then
        headY+=scaledHeadShirtMovement
        if headShirtDistance[2] >= -15.6*lineSize then
            if footYChange >= -1.6*lineSize then
                footYChange-=(1/3)*lineSize
            end
            shirtY+=scaledHeadShirtMovement
        end
    end
    if pd.buttonIsPressed(pd.kButtonLeft) then
        headX-=scaledHeadShirtMovement
        if headShirtDistance[1] <= -2.3*lineSize then
            shirtX-=scaledHeadShirtMovement
        end
    end
    if pd.buttonIsPressed(pd.kButtonRight) then
        headX+=scaledHeadShirtMovement
        if headShirtDistance[1] >= 2.3*lineSize then
            shirtX+=scaledHeadShirtMovement
        end
    end
    --zoom in and out --the line size also determines the size of everything
    if crankTicks == 1 then
        lineSize+=0.2
    elseif crankTicks == -1 then
        lineSize-=0.2
    end
end
