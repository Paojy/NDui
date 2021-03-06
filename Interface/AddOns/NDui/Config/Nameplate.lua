local _, C, _, _ = unpack(select(2, ...))

-- 法术白名单
C.WhiteList = {
	-- 种族技能
	[28730] 	= true,		-- 奥术洪流
	[20549] 	= true,		-- 战争践踏
	[107079] 	= true,		-- 震山掌
	-- 其他
	[226510]	= true,		-- 血池
	[207327]	= true,		-- M3净化毁灭
	[229495]	= true,		-- 象棋易伤
}

-- 法术黑名单
C.BlackList = {
	[15407]		= true,		-- 精神鞭笞
}