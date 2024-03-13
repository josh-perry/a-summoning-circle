local commandDone = false
local command

local dog = {
    alpha = 0,
    image = love.graphics.newImage("assets/img/dog.png")
}

local impact = love.audio.newSource("assets/audio/impact.mp3", "static")
local candle = love.audio.newSource("assets/audio/candle.mp3", "static")
local chanting = love.audio.newSource("assets/audio/chanting.mp3", "stream")
local pencil = love.audio.newSource("assets/audio/chalk.wav", "stream")
pencil:setLooping(true)

local woof = love.audio.newSource("assets/audio/woof.mp3", "static")

local candlesLit = false
local light = 0

local arcs = {}
local lines = {}

local font = love.graphics.newFont("assets/fonts/Moon Flower.ttf", 48)
love.graphics.setFont(font)

local animationCoroutine = coroutine.create(function()
    local function waitForCommand(key, text)
        commandDone = false
        command = {
            key = key,
            command = text
        }

        while commandDone == false do
            coroutine.yield("waiting")
        end
    end

    local function drawArc(circle, time)
        table.insert(arcs, circle)
        local steps = time / 0.01

        for i = 1, steps do
            circle.endAngle = (i / steps) * (math.pi * 2)
            coroutine.yield(0.01)
        end
    end

    local function drawLine(line, time)
        table.insert(lines, line)
        local steps = time / 0.01

        for i = 1, steps do
            line.currentEndPoint = {
                x = line.startPoint.x + (line.endPoint.x - line.startPoint.x) * (i / steps),
                y = line.startPoint.y + (line.endPoint.y - line.startPoint.y) * (i / steps)
            }

            coroutine.yield(0.01)
        end
    end

    local function drawStar(centerX, centerY, width, height)
        local points = {}

        for i = 1, 5 do
            local angle = (i / 5) * (math.pi * 2)

            table.insert(points, {
                x = centerX + math.cos(angle) * width,
                y = centerY + math.sin(angle) * height
            })
        end

        drawLine({
            startPoint = points[1],
            endPoint = points[3]
        }, 0.5)

        drawLine({
            startPoint = points[3],
            endPoint = points[5]
        }, 0.5)

        drawLine({
            startPoint = points[5],
            endPoint = points[2]
        }, 0.5)

        drawLine({
            startPoint = points[2],
            endPoint = points[4]
        }, 0.5)

        drawLine({
            startPoint = points[4],
            endPoint = points[1]
        }, 0.5)
    end

    waitForCommand("l", "light candles")
    candle:play()
    candlesLit = true

    waitForCommand("d", "draw the summoning circle")
    pencil:play()

    local outerCircle = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = 150,
        startAngle = 0,
        endAngle = 0
    }

    coroutine.yield(0.5)

    drawArc(outerCircle, 3)

    local innerCircle = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = 120,
        startAngle = 0,
        endAngle = 0
    }

    drawArc(innerCircle, 1)

    local runeCircleCount = 13
    for i = 1, runeCircleCount do
        local circle = {
            x = love.graphics.getWidth() / 2 + math.cos((i / runeCircleCount) * (math.pi * 2)) * (outerCircle.radius - 16),
            y = love.graphics.getHeight() / 2 + math.sin((i / runeCircleCount) * (math.pi * 2)) * (outerCircle.radius - 16),
            radius = 8,
            startAngle = 0,
            endAngle = 0
        }

        drawArc(circle, 0.1)
    end

    pencil:stop()
    waitForCommand("i", "draw the inner circle")
    pencil:play()

    local innerInnerCircle = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = 50,
        startAngle = 0,
        endAngle = 0
    }

    drawArc(innerInnerCircle, 1)

    local innerInnerInnerCircle = {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = 40,
        startAngle = 0,
        endAngle = 0
    }

    drawArc(innerInnerInnerCircle, 1)

    drawLine({
        startPoint = {
            x = love.graphics.getWidth() / 2,
            y = love.graphics.getHeight() / 2 - innerCircle.radius
        },
        endPoint = {
            x = love.graphics.getWidth() / 2 - innerCircle.radius,
            y = love.graphics.getHeight() / 2
        }
    }, 0.5)

    drawLine({
        startPoint = {
            x = love.graphics.getWidth() / 2 - innerCircle.radius,
            y = love.graphics.getHeight() / 2
        },
        endPoint = {
            x = love.graphics.getWidth() / 2,
            y = love.graphics.getHeight() / 2 + innerCircle.radius
        }
    }, 0.5)

    drawLine({
        startPoint = {
            x = love.graphics.getWidth() / 2,
            y = love.graphics.getHeight() / 2 + innerCircle.radius
        },
        endPoint = {
            x = love.graphics.getWidth() / 2 + innerCircle.radius,
            y = love.graphics.getHeight() / 2
        }
    }, 0.5)

    drawLine({
        startPoint = {
            x = love.graphics.getWidth() / 2 + innerCircle.radius,
            y = love.graphics.getHeight() / 2
        },
        endPoint = {
            x = love.graphics.getWidth() / 2,
            y = love.graphics.getHeight() / 2 - innerCircle.radius
        }
    }, 0.5)

    drawArc({
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2 - 80,
        radius = innerInnerCircle.radius / 2,
        startAngle = 0,
        endAngle = math.pi
    }, 0.5)

    drawArc({
        x = love.graphics.getWidth() / 2 - 80,
        y = love.graphics.getHeight() / 2,
        radius = innerInnerCircle.radius / 2,
        startAngle = 0,
        endAngle = math.pi
    }, 0.5)

    drawArc({
        x = love.graphics.getWidth() / 2 + 80,
        y = love.graphics.getHeight() / 2,
        radius = innerInnerCircle.radius / 2,
        startAngle = 0,
        endAngle = math.pi
    }, 0.5)

    drawArc({
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2 + 80,
        radius = innerInnerCircle.radius / 2,
        startAngle = 0,
        endAngle = math.pi
    }, 0.5)

    pencil:stop()

    waitForCommand("c", "chant")
    chanting:play()
    coroutine.yield(3)

    waitForCommand("s", "draw the star")
    pencil:play()
    drawStar(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, innerInnerInnerCircle.radius, innerInnerInnerCircle.radius)

    pencil:stop()
    waitForCommand("d", "summon")
    impact:play()
    coroutine.yield(4)

    for _ = 1, 100 do
        dog.alpha = dog.alpha + 0.01
        coroutine.yield(0.01)
    end

    woof:play()
    coroutine.yield(5)
    love.event.quit()
end)

function love.draw()
    love.graphics.setColor(1, 1, 1, 0.3 * light)

    local floorboardHeight = 50
    for x = 0, love.graphics.getWidth(), floorboardHeight do
        for y = 0, love.graphics.getHeight(), floorboardHeight do
            local line = {
                x, y,
                x + floorboardHeight, y - floorboardHeight
            }

            love.graphics.line(line)

            if x % (floorboardHeight * 2) == 0 and y % (floorboardHeight * 4) then
                local line = {
                    x, y,
                    x + floorboardHeight / 2, y + floorboardHeight / 2
                }

                love.graphics.line(line)
            end
        end
    end

    love.graphics.setColor(1, 0, 0, light)

    for _, arc in ipairs(arcs) do
        love.graphics.arc("line", "open", arc.x, arc.y, arc.radius, arc.startAngle, arc.endAngle)
    end

    for _, line in ipairs(lines) do
        love.graphics.line(line.startPoint.x, line.startPoint.y, line.currentEndPoint.x, line.currentEndPoint.y)
    end

    if command and not commandDone then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(("Press %s to %s"):format(string.upper(command.key), command.command), 0, 200, love.graphics.getWidth(), "center")
    end

    love.graphics.setColor(1, 1, 1, dog.alpha)
    love.graphics.draw(dog.image, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, 0.5, 0.5, dog.image:getWidth() / 2, dog.image:getHeight() / 2)
end

local delay = 1

function love.update(dt)
    if candlesLit then
        light = math.sin(love.timer.getTime() * 2) * 0.5 + 0.8
    end

    delay = delay - dt

    if delay <= 0 then
        local success, result = coroutine.resume(animationCoroutine)

        if not success then
            print("Error: " .. delay)
        end

        if type(result) == "string" then
            return
        elseif type(result) == "number" then
            delay = result
        end
    end
end

function love.keypressed(key)
    if key == command.key then
        commandDone = true
    end
end
