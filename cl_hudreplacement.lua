/*---------------------------------------------------------------------------
Which default HUD elements should be hidden?
---------------------------------------------------------------------------*/

local hideHUDElements = {
	-- if you DarkRP_HUD this to true, ALL of DarkRP's HUD will be disabled. That is the health bar and stuff,
	-- but also the agenda, the voice chat icons, lockdown text, player arrested text and the names above players' heads
	["DarkRP_HUD"] = true,

	-- DarkRP_EntityDisplay is the text that is drawn above a player when you look at them.
	-- This also draws the information on doors and vehicles
	["DarkRP_EntityDisplay"] = false,

	-- DarkRP_ZombieInfo draws information about zombies for admins who use /showzombie.
	["DarkRP_ZombieInfo"] = false,

	-- This is the one you're most likely to replace first
	-- DarkRP_LocalPlayerHUD is the default HUD you see on the bottom left of the screen
	-- It shows your health, job, salary and wallet, but NOT hunger (if you have hungermod enabled)
	["DarkRP_LocalPlayerHUD"] = false,

	-- If you have hungermod enabled, you will see a hunger bar in the DarkRP_LocalPlayerHUD
	-- This does not get disabled with DarkRP_LocalPlayerHUD so you will need to disable DarkRP_Hungermod too
	["DarkRP_Hungermod"] = false,

	-- Drawing the DarkRP agenda
	["DarkRP_Agenda"] = false
}

-- this is the code that actually disables the drawing.
hook.Add("HUDShouldDraw", "HideDefaultDarkRPHud", function(name)
	if hideHUDElements[name] then return false end
end)

/*---------------------------------------------------------------------------
	Draw the HUD
---------------------------------------------------------------------------*/

surface.CreateFont("HUDFont", {
	font = "Default",
	size = 20,
	weight = 300
})

-- Outline
local polydata = {}
polydata[1] = {}
polydata[1][1] = { x = ScrW() * 0.01, y = ScrH() * 0.83 }
polydata[1][2] = { x = ScrW() * 0.19, y = ScrH() * 0.83 }
polydata[1][3] = { x = ScrW() * 0.2601, y = ScrH() * 0.91 }
polydata[1][4] = { x = ScrW() * 0.2601, y = ScrH() * 0.97 }
polydata[1][5] = { x = ScrW() * 0.01, y = ScrH() * 0.97 }

-- Inner
local polydata1 = {}
polydata1[2] = {}
polydata1[2][1]= { x = ScrW() * 0.013, y = ScrH() * 0.835 }
polydata1[2][2]= { x = ScrW() * 0.19, y = ScrH() * 0.835 }
polydata1[2][3]= { x = ScrW() * 0.257, y = ScrH() * 0.912 }
polydata1[2][4]= { x = ScrW() * 0.257, y = ScrH() * 0.966 }
polydata1[2][5]= { x = ScrW() * 0.013, y = ScrH() * 0.966 }

local function addIcon(icon, x, y)
	surface.SetMaterial(Material(icon))
	surface.SetDrawColor(255, 255, 255, 255)
	surface.DrawTexturedRect(x, y, 16, 16)
end

local function Avatar()
	local Avatar = vgui.Create("AvatarImage")
	Avatar:SetSize(ScrW() / 2 * 0.136, ScrW() / 2 * 0.138)
	Avatar:SetPos(ScrW() * 0.016, ScrH() * 0.840)
	Avatar:SetPlayer(LocalPlayer(), 64)
end
timer.Simple(0.1, function()
	Avatar()
end)

local function AddComma(n)
	local sn = tostring(n)
	local tab = {}
	sn = string.ToTable(sn)
	for i=0,#sn-1 do
		if i%3 == #sn%3 and !(i==0) then
			table.insert(tab, ",")
		end
		table.insert(tab, sn[i+1])
	end
	return string.Implode("", tab)
end
	
local function hudPaint()
	local x, y = ScrW(), ScrH()
	local _ply = LocalPlayer()
	
	local Job = _ply.DarkRPVars.job
	local Mon = _ply.DarkRPVars.money
	local Sal = _ply.DarkRPVars.salary
	
	surface.SetDrawColor(Color(0, 0, 0, 125))
	table.foreachi(polydata, function(k,v) 
		surface.DrawPoly(v) 
	end)
	
	surface.SetDrawColor(Color(0, 0, 0, 175))
	table.foreachi(polydata1, function(k,v) 
		surface.DrawPoly(v) 
	end)
	
	-- Icons
	addIcon("icon16/group.png", ScrW() * 0.086, ScrH() * 0.842)
	addIcon("icon16/money.png", ScrW() * 0.086, ScrH() * 0.865)
	addIcon("icon16/user.png", ScrW() * 0.086, ScrH() * 0.886)
	
	-- Information
	draw.SimpleText("Job: "..Job, "Trebuchet22", 				ScrW() * 0.096, ScrH() * 0.882, Color(255, 255, 255))
	draw.SimpleText("Money: "..AddComma(Mon), "Trebuchet22", 	ScrW() * 0.096, ScrH() * 0.860, Color(255, 255, 255))
	draw.SimpleText(LocalPlayer():Nick(), "Trebuchet22", 		ScrW() * 0.096, ScrH() * 0.838, Color(255, 255, 255, 255))
	
	local x, y = ScrW() * 0.086, ScrH() * 0.913
	local w, h = ScrW() * 0.160, 20
	local bar =  math.max(w * (_ply:Health() / 100), 1)
	
	draw.RoundedBox(0, x, y, w, h, Color(0, 0, 0, 255))
	draw.RoundedBox(0, x, y, bar, h, Color(255, 0, 0, 255))
	draw.SimpleText("Health: ".._ply:Health(), "HUDFont", x + 24*0.5, y - 2, Color(255, 255, 255))
	
	if _ply:Armor() ~= 0 then
		local x, y = ScrW() * 0.086, ScrH() * 0.936
		local w, h = ScrW() * 0.160, 20
		local bar =  math.max(w * (_ply:Armor() / 100), 1)
	
		draw.RoundedBox(0, x, y, w, h, Color(0, 0, 0, 255))
		draw.RoundedBox(0, x, y, bar, h, Color(0, 56, 255, 255))
		draw.SimpleText("Armor: ".._ply:Armor(), "HUDFont", x + 24*0.5, y - 1, Color(255, 255, 255))
	end
	
	--draw.RoundedBox(0, ScrW() * 0.086, ScrH() * 0.934, 320, 15, Color(0, 0, 255, 255))
	
	--draw.RoundedBox(0, ScrW() * 0.013, ScrH() * 0.97, 200, 100, Color(255, 0, 0, 255))
end
hook.Add("HUDPaint", "DarkRP_Mod_HUDPaint", hudPaint)
