local pd <const> = playdate
local gfx <const> = pd.graphics

import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/crank'

image1 = gfx.image.new("images/image")
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
    
    --head
    head = gfx.sprite.new(gfx.drawCircleAtPoint(
        headPosition[1],
        headPosition[2],
        --headsize
        headDiameter
    ))
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
        if footPosition2[1] <= shirtBottom[1] then
            footSliding2 = false
        end
    else
        if footPosition2[1] >= shirtBottom[1] then
            footSliding2 = false
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
            footPosition2[1] = headPosition[1]
            footSliding2 = true
        end
    end
    --movement
    if pd.buttonIsPressed(pd.kButtonUp) then
        headY-=1.4
        --moves the shirt and feet with a delay to the head
        if headShirtDistance[2] <= -56 then
            --moves feet with delay too shirt
            if footYChange <= 0 then
                footYChange+=1
            end
            shirtY-=1.4
        end
    end
    if pd.buttonIsPressed(pd.kButtonDown) then
        headY+=1.4
        if headShirtDistance[2] >= -47 then
            if footYChange >= -5 then
                footYChange-=1
            end
            shirtY+=1.4
        end
    end
    if pd.buttonIsPressed(pd.kButtonLeft) then
        headX-=1.4
        if headShirtDistance[1] <= -7 then
            shirtX-=1.4
        end
    end
    if pd.buttonIsPressed(pd.kButtonRight) then
        headX+=1.4
        if headShirtDistance[1] >= 7 then
            shirtX+=1.4
        end
    end
    --zoom in and out --the line size also determines the size of everything
    if crankTicks == 1 then
        lineSize+=0.2
    elseif crankTicks == -1 then
        lineSize-=0.2
    end
end
