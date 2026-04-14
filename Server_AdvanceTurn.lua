-- Server_AdvanceTurn.lua
-- "Stationary Commander" mod
--
-- Commanders cannot move or attack. When armies leave a territory that has
-- a commander included in the order's armies, the order is cancelled and
-- re-issued without the commander.
--
-- Optionally (configurable at game setup), airlifts from a commander's
-- territory that include the commander are also blocked.
--
-- Commanders still defend normally.

function Server_AdvanceTurn_Start(game, addNewOrder)
end

-- Find the commander belonging to playerID in an Armies object.
-- Returns the SpecialUnit object, or nil if not found.
local function findCommanderInArmies(armies, playerID)
    local units = armies.SpecialUnits
    if units == nil then return nil end
    for _, unit in ipairs(units) do
        if unit.OwnerID == playerID and unit.proxyType == 'Commander' then
            return unit
        end
    end
    return nil
end

function Server_AdvanceTurn_Order(game, order, orderResult, skipThisOrder, addNewOrder)
    local playerID  = order.PlayerID
    local commander = nil
    local isAirlift = false

    if order.proxyType == 'GameOrderAttackTransfer' then
        commander = findCommanderInArmies(order.NumArmies, playerID)

    elseif order.proxyType == 'GameOrderPlayCardAirlift' then
        -- Only intercept airlifts if the setting is enabled
        if Mod.Settings.BlockAirlifts ~= true then return end
        commander = findCommanderInArmies(order.Armies, playerID)
        isAirlift = true
    else
        return
    end

    if commander == nil then return end

    -- Skip the original order silently and re-issue without the commander
    skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)

    if isAirlift then
        -- Re-issue airlift with commander stripped from armies
        local commanderArmies       = WL.Armies.Create(0, { commander })
        local armiesWithoutCommander = order.Armies.Subtract(commanderArmies)

        -- If only the commander was being airlifted, cancel entirely
        if armiesWithoutCommander.IsEmpty then return end

        addNewOrder(WL.GameOrderPlayCardAirlift.Create(
            order.CardInstanceID,
            playerID,
            order.FromTerritoryID,
            order.ToTerritoryID,
            armiesWithoutCommander
        ))
    else
        -- Re-issue attack/transfer with commander stripped from armies
        local commanderArmies       = WL.Armies.Create(0, { commander })
        local armiesWithoutCommander = order.NumArmies.Subtract(commanderArmies)

        -- If only the commander was attacking, cancel entirely
        if armiesWithoutCommander.IsEmpty then return end

        addNewOrder(WL.GameOrderAttackTransfer.Create(
            playerID,
            order.From,
            order.To,
            order.AttackTransfer,
            order.ByPercent,
            armiesWithoutCommander,
            order.AttackTeammates
        ))
    end
end

function Server_AdvanceTurn_End(game, addNewOrder)
end
