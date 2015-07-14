require "Cocos2d"
require "Cocos2dConstants"

local Ship = class("Ship", function ()
    local texture = cc.Director:getInstance():getTextureCache():addImage("ship.png");
    local rect = cc.rect(0,0,1024,528);
    local frame = cc.SpriteFrame:createWithTexture(texture,rect);
    return cc.Sprite:createWithSpriteFrame(frame); 
end);

function Ship.create()
    local ship = Ship.new();
    return ship;
end

function Ship:ctor()
    self:setScale(0.05);
    self.ax = 0;
    self.ay = 0;
    self.vx = 0;
    self.vy = 0;
    self.smoke = cc.ParticleSmoke:create();
    self.smoke:setAngle(math.pi / 2);
    self.smoke:setAngleVar(360);
    self.smoke:setScale(3);
    self.smoke:setPosition(-60,240);
    self.smoke:setGravity(cc.p(-30, 0));
    self.smoke:setStartColor(cc.c4f(1.0,0.5,0,1.0));
    self.smoke:setEndColor(cc.c4f(1.0,1.0,1.0,1.0));
    self:addChild(self.smoke);
end

return Ship;