-- Client_SaveConfigureUI.lua

function Client_SaveConfigureUI(alert, addCard)
    Mod.Settings.BlockAirlifts = _SCMod_blockAirliftsCheckbox.GetIsChecked()
end
