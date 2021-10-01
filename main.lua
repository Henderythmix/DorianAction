function love.load(args)
    -- Requirements
    local json = require "json"

    -- VARIABLES --
    configFile = love.filesystem.read("example.json")
    configData = json.decode(configFile)
    -- Statically Generated Info
    categories = {}
    clength = 0
    programs = {}

    -- Generation Process
    for c=1, table.getn(configData["Categories"]) do
	categories[c] = configData["Categories"][c]["Name"]
	clength = clength + 1
	programs[c] = {}
	for p=1, table.getn(configData["Categories"][c]["Commands"]) do
	    programs[c][p] = configData["Categories"][c]["Commands"][p]["Name"]
	end
    end
    

    -- Dynamic Variables
    selectionDepth = 0
    highlightedCategory = nil
    highlightedOption = 1

end

function love.keypressed(k)
    if k == 'up' then
	if highlightedOption > 1 then
	    highlightedOption = highlightedOption - 1
	end
    elseif k == 'down' then
	highlightedOption = highlightedOption + 1
    end

    if k == "escape" or k == "backspace" then
	if selectionDepth == 0 then
	    love.event.quit()
	else
	    selectionDepth = selectionDepth - 1
	    highlightedOption = 1
	end
    end

    if k == "return" or k == "space" then
	if selectionDepth == 0 then
	    selectionDepth = selectionDepth + 1
	    highlightedCategory = highlightedOption
	    highlightedOption = 1
	elseif selectionDepth == 1 then
	    os.execute(configData["Categories"][highlightedCategory]["Commands"][highlightedOption]["Command"].." &")
	    love.event.quit()
	end
    end
    --print(highlightedCategory)
end

function love.draw()
    love.graphics.setBackgroundColor(configData["Background-Color"])
    love.graphics.setColor(configData["Text-Color"])
    
    love.graphics.print(">", 10, 10+((highlightedOption-1) * 18))

    if selectionDepth == 0 then
        for c=1,clength do
	    love.graphics.print(categories[c], 30,10+((c-1)*18))
	end
    else
	for p=1, table.getn(programs[highlightedCategory]) do
	    love.graphics.print(programs[highlightedCategory][p], 30, 10+((p-1)*18))
	end
    end
end
