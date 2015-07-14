require "Cocos2d"
require "Cocos2dConstants"

local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)

function GameScene.create()
    local scene = GameScene.new()

    scene:addChild(scene:createLayerBackground());
    scene:addChild(require("Playboard").create());
    return scene
end


function GameScene:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize()
    self.origin = cc.Director:getInstance():getVisibleOrigin()
    self.schedulerID = nil
end

function GameScene:playBgMusic()
    local bgMusicPath = cc.FileUtils:getInstance():fullPathForFilename("background.mp3") 
    cc.SimpleAudioEngine:getInstance():playMusic(bgMusicPath, true)
    local effectPath = cc.FileUtils:getInstance():fullPathForFilename("effect1.wav")
    cc.SimpleAudioEngine:getInstance():preloadEffect(effectPath)
end

function GameScene:createLayerBackground()
    local layer = cc.LayerColor:create(cc.c4b(0,0,0,255));
    local d1 = 1;
    local i = 0;
    function change ()
        i = i + d1;
        if i == 212 then
            d1 = -1;
        end
        if i == 0 then
            d1 = 1;
        end
        layer:setColor(cc.c3b(i * 1.2,i,0));
    end
    
    layer.scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(change, 0, false)
    return layer;
end

return GameScene
