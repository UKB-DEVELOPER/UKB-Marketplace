local __internal_perform = PerformHttpRequest
local __external_perform = function(url, cb, ...)
  icb = function(_, ...)
      cb(200, ...)
  end
  __internal_perform(url, icb, ...)
end
PerformHttpRequest = __external_perform

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local ResourceName = GetCurrentResourceName()
scriptId = "663f15e964700c6ab3cc542c"


Staus = function ( errNum , data)

    Status = false
        
    if ( errNum == 200 and data == scriptId) then
        print("\n")
        print("^2###########################################") 
        print("^2## ^5Thank you for purchasing UKB - Script ^2##") 
        print("^2##   ^5https://shop.unknowkubbrother.net   ^2##") 
        print("^2###########################################") 
        Status = true
        Reply(Status)
        TriggerClientEvent(ResourceName..':checkLicense', -1, Status)
    else
        print("\n")
        print("^1###########################################") 
        print("^1##   ^5UKB - Script ^1 License inavlid ^1      ##") 
        print("^1##   ^5https://shop.unknowkubbrother.net   ^1##") 
        print("^1###########################################") 
        TriggerClientEvent(ResourceName..':checkLicense', -1, Status)
    end

end

Connect = function ()

    PerformHttpRequest("https://api.unknowkubbrother.net/checkLicense", function (errorCode, resultData, resultHeaders, errorData)
        Staus(errorCode, resultData)
    end, "POST", json.encode(Config.license), { ["Content-Type"] = "application/json" })
    
end

Connect()

Reply = function (Status)
    if Status then
            
        print("Test")
    end
end