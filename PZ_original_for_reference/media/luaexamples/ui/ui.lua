require 'ui/uiHelpers'

local clickCounter = 0;

-- UI objects
local mywindow =
	{		
		onButtonClicked = function(name)
			clickCounter = clickCounter + 1;
		end,
		
		render = function(element) 
			element:DrawTextCentre("Has been clicked "..clickCounter.." times.", 150, 100, 1, 0, 0, 1);
		end,
		
		x = 100,
		y = 100,
		width = 300,
		height = 300,		
		hasClose = true;
	};

local mybutton =
	{
		parent=mywindow,
		name="testButton",
		text="Bob's Button",
		x=150,
		y=250;		
	}
	
local mygenericelement =
	{		
		x=150,
		y=250,
		width=120,
		height=120,
		render = function(element)
			element:DrawTextCentre("Test Render", 150, 100, 1, 0, 0, 1);
			local player = getPlayer();
			
			local equippeditem = player:getPrimaryHandItem();
			
			if equippeditem ~= nil then
				local texture = equippeditem:getTexture();
				element:DrawTexture(texture, 0, 0, 0.3);
			end
		end;		
	}

function CreateTest()

	--LuaUI.createWindow(mywindow);
	--LuaUI.createButton(mybutton);
	--element = LuaUI.createElement(mygenericelement);
	
end
