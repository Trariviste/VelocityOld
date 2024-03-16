local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
local button = Instance.new("TextButton")
button.Name = "PressVButton"
button.Text = "Vape"
button.Size = UDim2.new(0.05, 0, 0.05, 0)
button.Position = UDim2.new(0.9, 0, 0.5, 0)
button.Parent = screenGui
local isDragging = false
local startPosition = UDim2.new()
local startInputPosition = Vector2.new()
local function updatePosition(inputPosition)
    local delta = inputPosition - startInputPosition
    button.Position = startPosition + UDim2.new(0, delta.X, 0, delta.Y)
end
local function onInput(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.UserInputState == Enum.UserInputState.Begin then
            isDragging = true
            startPosition = button.Position
            startInputPosition = input.Position
        elseif input.UserInputState == Enum.UserInputState.End then
            isDragging = false
        end
    elseif input.UserInputType == Enum.UserInputType.MouseMovement then
        if isDragging then
            updatePosition(input.Position)
        end
    end
end
UserInputService.InputBegan:Connect(onInput)
UserInputService.InputChanged:Connect(onInput)
local function onButtonClicked()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.V, false, game)
end
button.MouseButton1Click:Connect(onButtonClicked)
local errorPopupShown = false
local setidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end
local getidentity = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity or function() return 8 end
local isfile = isfile or function(file)
    local suc, res = pcall(function() return readfile(file) end)
    return suc and res ~= nil
end
local delfile = delfile or function(file) writefile(file, "") end

local function displayErrorPopup(text, func)
    local oldidentity = getidentity()
    setidentity(8)
    local ErrorPrompt = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.ErrorPrompt)
    local prompt = ErrorPrompt.new("Default")
    prompt._hideErrorCode = true
    local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    prompt:setErrorTitle("Vape")
    prompt:updateButtons({{
        Text = "OK",
        Callback = function() 
            prompt:_close() 
            if func then func() end
        end,
        Primary = true
    }}, 'Default')
    prompt:setParent(gui)
    prompt:_open(text)
    setidentity(oldidentity)
end

local function vapeGithubRequest(scripturl)
    if not isfile("vape/"..scripturl) then
        local suc, res
        task.delay(15, function()
            if not res and not errorPopupShown then 
                errorPopupShown = true
                displayErrorPopup("The connection to GitHub is taking a while. Please be patient.")
            end
        end)
        suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/"..readfile("vape/commithash.txt").."/"..scripturl, true) end)
        if not suc or res == "404: Not Found" then
            displayErrorPopup("Failed to connect to GitHub: vape/"..scripturl.." : "..res)
            error(res)
        end
        if scripturl:find(".lua") then res = "--This watermark is used to delete the file if it's cached. Remove it to make the file persist after commits.\n"..res end
        writefile("vape/"..scripturl, res)
    end
    return readfile("vape/"..scripturl)
end

if not shared.VapeDeveloper then 
    local commit = "main"
    for i,v in pairs(game:HttpGet("https://github.com/7GrandDadPGN/VapeV4ForRoblox"):split("\n")) do 
        if v:find("commit") and v:find("fragment") then 
            local str = v:split("/")[5]
            commit = str:sub(0, str:find('"') - 1)
            break
        end
    end
    if commit then
        if isfolder("vape") then 
            if ((not isfile("vape/commithash.txt")) or (readfile("vape/commithash.txt") ~= commit or commit == "main")) then
                writefile("vape/commithash.txt", commit)
            end
        else
            makefolder("vape")
            writefile("vape/commithash.txt", commit)
        end
    else
        displayErrorPopup("Failed to connect to GitHub. Please try using a VPN.")
        error("Failed to connect to GitHub. Please try using a VPN.")
    end
end

return loadstring(vapeGithubRequest("MainScript.lua"))()
