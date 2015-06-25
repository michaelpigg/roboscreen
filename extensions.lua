extensions = {}
extensions.pstn = {}
extensions.pstn["ht503fxo"] = function()
  if checkCall() then
    app.verbose(1, "external caller is good, attempting to forward call")
    app.dial("SIP/ht503fxs", 30, "m")
  end
end

function checkCall()
  cid = channel.CALLERID("number"):get()
  if isWhitelisted(cid) == false then
   app.answer()
   if isRobot(cid, 3) then
     app.verbose(1, cid .. "appers to be a robot")
     channel.DB("robots/" .. cid):set(os.date())
     app.hangup()
     return false
   else
     app.verbose(1, cid .. " is cool, adding to whitelist")
     channel.DB("whitelist/" .. cid):set(os.date())
     channel.DB_DELETE("robots/" .. cid):get()
   end
  end
  return true
end

function isWhitelisted(cid)
  if channel.DB_EXISTS("whitelist/" .. cid):get() == "1" then
    app.verbose(1, cid .. " is in the whitelist, not a robot")
    return true
  end
  app.verbose(2, cid .. " not found in whitelist")
  return false
end

function isRobot(cid, tries)
  app.verbose(2, "checking whether cid " .. cid .. " is a robot")
  if (tries < 1) then
    return true
  else
    if robotChallenge() then
      return false
    else
      app.verbose(2, cid .. " failed robot challenge on try " .. tries)
      return isRobot(cid, tries - 1)
    end
  end
end

function robotChallenge()
  digit = channel.RAND(0, 9):get()
  app.playback("custom/MainGreeting")
  app.wait(1)
  app.playback("custom/NotRecognized")
  app.playback("custom/ContinuePleasePress")
  app.saynumber(digit,"f")
  channel.entered = -1
  app.read("entered","",1)
  app.verbose(2, "challenge is " .. digit .. "; entered is" .. channel.entered:get() )
  return digit == channel.entered:get()
end

extensions.internal = {}
extensions.internal["100"] = function()
  app.dial("SIP/ext100")
end

extensions.internal["housemain"] = function()
  app.dial("SIP/ht503fxs", 30, m)
end

