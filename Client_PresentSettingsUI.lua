-- Client_PresentSettingsUI.lua

function Client_PresentSettingsUI(rootParent)
    local vert = UI.CreateVerticalLayoutGroup(rootParent)

    UI.CreateLabel(vert)
        .SetText('Stationary Commander')
        .SetColor('#FFD700')

    local blockAirlifts = Mod.Settings.BlockAirlifts == true

    UI.CreateLabel(vert)
        .SetText('Commanders cannot move or attack. Armies leave without them.\n\n'
                 .. 'Block airlifting commander: ' .. (blockAirlifts and 'Yes' or 'No'))
end
