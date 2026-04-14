-- Client_PresentConfigureUI.lua

function Client_PresentConfigureUI(rootParent)
    local vert = UI.CreateVerticalLayoutGroup(rootParent)

    UI.CreateLabel(vert)
        .SetText('Stationary Commander')
        .SetColor('#FFD700')

    UI.CreateLabel(vert)
        .SetText('Commanders cannot move or attack. Armies leave without them.')

    local cb = UI.CreateCheckBox(vert)
        .SetText('Also prevent airlifting the commander')
        .SetIsChecked(Mod.Settings.BlockAirlifts == true)

    _SCMod_blockAirliftsCheckbox = cb
end
