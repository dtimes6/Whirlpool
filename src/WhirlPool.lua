require "Cocos2d"
require "Cocos2dConstants"

local WhirlPool = class("WhirlPool", function()
    return cc.ParticleGalaxy:create();
end)

function WhirlPool.create()
    local whirlpool = WhirlPool.new();
    return whirlpool;
end

function WhirlPool:ctor()
    self:renew();
end

function WhirlPool:renew()
    self.force = math.random(1,600) * 0.001;
    self:setScale(self.force);
    if math.random(1,10) < 5 then
        self:setStartColor(cc.c4f(1.0, 0.5, 0, 1.0));
        self:setEndColor(cc.c4f(1.0, 0.5, 0, 1.0));
        self.force = -self.force;
    end
end

return WhirlPool;