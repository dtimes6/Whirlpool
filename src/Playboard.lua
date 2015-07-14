require "Cocos2d"
require "Cocos2dConstants"

Ship = require("Ship");
WhirlPool = require("WhirlPool");

local PlayBoardLayer = class("PlayBoardLayer", function()
    return cc.Layer:create();
end)

function PlayBoardLayer.create()
    local layer = PlayBoardLayer.new();
    return layer; 
end

function PlayBoardLayer:ctor()
    self.visibleSize = cc.Director:getInstance():getVisibleSize();
    self.origin = cc.Director:getInstance():getVisibleOrigin();
    self.mess_unit = 50;
    self.whirlpools = {};
    self:generate(50);
    
    local ship = Ship.create();
    ship.x = self.origin.x + self.visibleSize.width / 2;
    ship.y = self.origin.y + self.visibleSize.height / 2;
    ship:setPosition(ship.x, ship.y);
    self:addChild(ship);
    self.ship = ship;
    
    local this = self;
    function tick()
        this:force();
        ship = this.ship;
        ship.vx = ship.vx + ship.ax;
        ship.vy = ship.vy + ship.ay;
        this:updatePosition();
    end
    
    self.scheduleId = cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick, 0, false);
    
    -- accelerometer
    self:setAccelerometerEnabled(true);
    local function accelerometerListener(event,x,y,z,timestamp)
        self.ship.ax = self.ship.ax - x * 100;
        self.ship.ay = self.ship.ay - y * 100;
        ship.smoke:setGravity(cc.p(x * 100, y * 100));
    end
    local listerner  = cc.EventListenerAcceleration:create(accelerometerListener);
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listerner, self);
end

function PlayBoardLayer:generate(count) 
    for i = 1, count do
        self:makeWhirlPool();
    end
end

function PlayBoardLayer:makeWhirlPool()
    local whirlpool = WhirlPool.create();
    whirlpool.x = self.origin.x + math.random(0,self.visibleSize.width * 3) - self.visibleSize.width;
    whirlpool.y = self.origin.y + math.random(0,self.visibleSize.height * 3) - self.visibleSize.height;
    whirlpool:setPosition(whirlpool.x,whirlpool.y);
    self:addChild(whirlpool);
    self.whirlpools[#self.whirlpools + 1] = whirlpool;
end

function PlayBoardLayer:force()
    local ax = 0;
    local ay = 0;
    
    local ship = self.ship;
    for i = 1, #self.whirlpools do
        local whirlpool = self.whirlpools[i];
        local dx = ship.x - whirlpool.x;
        local dy = ship.y - whirlpool.y;
        local dc = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
        
        ax = ax + whirlpool.force * dx / math.pow(dc, 3) * self.mess_unit;
        ay = ay + whirlpool.force * dy / math.pow(dc, 3) * self.mess_unit;
    end
    ship.ax = ax;
    ship.ay = ay;
end

function PlayBoardLayer:updatePosition()
    local ship = self.ship;
    for i = 1, #self.whirlpools do
        local whirlpool = self.whirlpools[i];
        whirlpool.x = whirlpool.x - ship.vx;
        whirlpool.y = whirlpool.y - ship.vy;
        -- adjust x
        while whirlpool.x < self.origin.x - self.visibleSize.width do
            whirlpool.x = whirlpool.x + self.visibleSize.width * 3;
        end
        while whirlpool.x > self.origin.x + self.visibleSize.width * 2 do
            whirlpool.x = whirlpool.x - self.visibleSize.width * 3;
        end
        -- adjust y
        while whirlpool.y < self.origin.y - self.visibleSize.height do
            whirlpool.y = whirlpool.y + self.visibleSize.height * 3;
        end
        while whirlpool.y > self.origin.y + self.visibleSize.height * 2 do
            whirlpool.y = whirlpool.y - self.visibleSize.height * 3;
        end
        
        whirlpool:setPosition(whirlpool.x, whirlpool.y);
    end
end

return PlayBoardLayer;