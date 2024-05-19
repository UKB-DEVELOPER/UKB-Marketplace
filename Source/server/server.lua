ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local ResourceName = GetCurrentResourceName()

RegisterServerEvent(ResourceName..':BuyItem')
AddEventHandler(ResourceName..':BuyItem', function(item, Total, typePayment)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    print("Money",xPlayer.getMoney())
    print("Bank",xPlayer.getAccount('bank').money)
    if not xPlayer then return end
    if typePayment == 'Cash' then
        if xPlayer.getMoney() >= tonumber(Total) then
            xPlayer.removeMoney(tonumber(Total))
            for k, v in pairs(item) do
                xPlayer.addInventoryItem(v.name, tonumber(v.count))
            end
            Shop.NotifyServer(source, 'success', 'ซื้อสินค้าสำเร็จ')
        else
            Shop.NotifyServer(source, 'error', 'คุณมีเงินในตัวไม่พอ')
        end
    elseif typePayment == 'Bank' then
        if xPlayer.getAccount('bank').money >= tonumber(Total) then
            xPlayer.removeAccountMoney('bank', tonumber(Total))
            for k, v in pairs(item) do
                xPlayer.addInventoryItem(v.name, tonumber(v.count))
            end
            Shop.NotifyServer(source, 'success', 'ซื้อสินค้าสำเร็จ')
        else
            Shop.NotifyServer(source, 'error', 'คุณมีเงินในธนาคารคุณไม่พอ')
        end
    end

end)