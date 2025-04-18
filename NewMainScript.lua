--[[         _____                    _____                    _____                   _____          
        /\    \                  /\    \                  /\    \                 /\    \         
       /::\____\                /::\    \                /::\    \               /::\    \        
      /:::/    /               /::::\    \              /::::\    \             /::::\    \       
     /:::/    /               /::::::\    \            /::::::\    \           /::::::\    \      
    /:::/    /               /:::/\:::\    \          /:::/\:::\    \         /:::/\:::\    \     
   /:::/____/               /:::/__\:::\    \        /:::/__\:::\    \       /:::/__\:::\    \    
   |::|    |               /::::\   \:::\    \      /::::\   \:::\    \     /::::\   \:::\    \   
   |::|    |     _____    /::::::\   \:::\    \    /::::::\   \:::\    \   /::::::\   \:::\    \  
   |::|    |    /\    \  /:::/\:::\   \:::\    \  /:::/\:::\   \:::\____\ /:::/\:::\   \:::\    \ 
   |::|    |   /::\____\/:::/  \:::\   \:::\____\/:::/  \:::\   \:::|    /:::/__\:::\   \:::\____\
   |::|    |  /:::/    /\::/    \:::\  /:::/    /\::/    \:::\  /:::|____\:::\   \:::\   \::/    /
   |::|    | /:::/    /  \/____/ \:::\/:::/    /  \/_____/\:::\/:::/    / \:::\   \:::\   \/____/ 
   |::|____|/:::/    /            \::::::/    /            \::::::/    /   \:::\   \:::\    \     
   |:::::::::::/    /              \::::/    /              \::::/    /     \:::\   \:::\____\    
   \::::::::::/____/               /:::/    /                \::/____/       \:::\   \::/    /    
    ~~~~~~~~~~                    /:::/    /                  ~~              \:::\   \/____/     
                                 /:::/    /                                    \:::\    \         
                                /:::/    /                                      \:::\____\        
                                \::/    /                                        \::/    /        
                                 \/____/                                          \/____/         

    The #1 Roblox Bedwars Script on the market.

        - Xylex/7GrandDad - developer / organizer
]]--

local errorPopupShown: boolean = false;
local setidentity: (any) -> () = syn and syn.set_thread_identity or set_thread_identity or setidentity or setthreadidentity or function() end;
local getidentity: () -> any = syn and syn.get_thread_identity or get_thread_identity or getidentity or getthreadidentity or function() return 8; end;
local isfile: (string) -> boolean = isfile or function(file: string): boolean
    local suc, res = pcall(function() return readfile(file) end);
    return suc and res ~= nil;
end;
local delfile: (string) -> () = delfile or function(file: string): () writefile(file, "") end;

local function displayErrorPopup(text: any, func: () -> (a...))
    local oldidentity: number = getidentity();
    setidentity(8);
    local ErrorPrompt: ErrorPrompt = getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.ErrorPrompt);
    local prompt: ErrorPromptInstance = ErrorPrompt.new("Default");
    prompt._hideErrorCode = true;
    local gui: ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"));
    prompt:setErrorTitle("Vape");
    prompt:updateButtons({{
        Text = "OK",
        Callback = function(): () 
            prompt:_close() 
            if func then func() end
        end,
        Primary = true
    }}, 'Default')
    prompt:setParent(gui);
    prompt:_open(text);
    setidentity(oldidentity);
end;

local function vapeGithubRequest(scripturl: string): string
    if not isfile("vape/"..scripturl) then
        local suc: boolean, res: string;
        task.delay(15, function()
            if not res and not errorPopupShown then 
                errorPopupShown = true;
                displayErrorPopup("The connection to GitHub is taking a while. Please be patient.");
            end;
        end);
        suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/Copiums/VelocityOld/"..readfile("vape/commithash.txt").."/"..scripturl, true) end);
        if not suc or res == "404: Not Found" then
            displayErrorPopup("Failed to connect to GitHub: vape/"..scripturl.." : "..res);
            error(res);
        end;
        if scripturl:find(".lua") then res = "--This watermark is used to delete the file if it's cached. Remove it to make the file persist after commits.\n"..res; end;
        writefile("vape/"..scripturl, res);
    end;
    return readfile("vape/"..scripturl);
end;

if not shared.VapeDeveloper then 
    local commit: string = "main";
    for i: number, v: string in pairs(game:HttpGet("https://github.com/7GrandDadPGN/VapeV4ForRoblox"):split("\n")) do 
        if v:find("commit") and v:find("fragment") then 
            local str: string = v:split("/")[5];
            commit = str:sub(0, str:find('"') - 1);
            break;
        end;
    end;
    if commit then
        if isfolder("vape") then 
            if ((not isfile("vape/commithash.txt")) or (readfile("vape/commithash.txt") ~= commit or commit == "main")) then
                writefile("vape/commithash.txt", commit);
            end;
        else
            makefolder("vape");
            writefile("vape/commithash.txt", commit);
        end;
    else
        displayErrorPopup("Failed to connect to GitHub. Please try using a VPN.");
        error("Failed to connect to GitHub. Please try using a VPN.");
    end;
end;

return loadstring(vapeGithubRequest("MainScript.lua"))();
