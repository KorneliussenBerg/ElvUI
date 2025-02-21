local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule('Skins')

local _G = _G
local hooksecurefunc = hooksecurefunc

local backdrops = {}
local function SkinFrame(frame)
	frame:StripTextures()

	if backdrops[frame] then
		frame.backdrop = backdrops[frame] -- relink it back
	else
		frame:CreateBackdrop('Transparent') -- :SetTemplate errors out
		backdrops[frame] = frame.backdrop -- keep below CreateBackdrop

		if frame.ScrollBar then
			S:HandleTrimScrollBar(frame.ScrollBar)
		end
	end
end

function S:OpenMenu(region, menuDescription)
	local menu = self:GetOpenMenu() -- self is manager (Menu.GetManager)
	if menu then
		-- Initial context menu
		SkinFrame(menu)
		-- SubMenus
		menuDescription:AddMenuAcquiredCallback(SkinFrame)
	end
end

function S:Blizzard_Menu()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.misc) then return end

	local manager = _G.Menu.GetManager()
	if manager then
		hooksecurefunc(manager, 'OpenMenu', S.OpenMenu)
		hooksecurefunc(manager, 'OpenContextMenu', S.OpenMenu)
	end
end

S:AddCallbackForAddon('Blizzard_Menu')
