pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

local nbot2 = {} -- our dude
local state	= "" -- game state
local lasers = {} -- keep track of lasers
local superlasers = {} -- keep track of super lasers
local badguys = {} -- keep track of bad guys
local t = 0 -- keep track of time

function _init() 
 cls()
 palt(0, false) 
 sfx(6)
 state = "title"
end

function _update() 
 
	if(state == "title") then
			if(btnp(4)) then
				game_init()
				state = "play"
			end
	end

end

function _draw() 
	
	cls()

	t = (t+1)%60
	
	-- check if we are in title mode.
	if(state == "title") then
	  -- draw title.
	  print("n^2+e games",45, 50)
			return
	end
	
	-- calc any movement to our ship.
	move_ship()

	-- draw some background stuff
	spr(43, 10, 10)
	spr(45, 16, 16)
	spr(47, 75, 26)

	-- generate new bad guys
	 if(t==0) then 
   		generate_badguys()
 	end


	-- draw the bad guys
	for b in all(badguys) do 
		
		spr(b.sprite, b.x, b.y)

		if(b.alive) then
			b.y += 2
		end

		--- test if bad guys collide with player.
		if(nbot2.y >= b.y and nbot2.y <= b.y+10 
			and nbot2.x >= b.x and nbot2.x <= b.x+10) and b.alive then
			nbot2.sprite = 28
			sfx(10)

			if(nbot2.alive) then 
				sfx(7)
			end

			nbot2.alive = false
			
		end

		--- clean up uneeded bad guys
		if(b.y > 100) then
			del(badguys,b)
		end
	end

	-- draw our world.
	for l in all(lasers) do 
		spr(l.sprite, l.x, l.y)
		l.y -= 3

		-- test for collisions
		for b in all(badguys) do
			if(l.y >= b.y and l.y <= b.y+10 
				and l.x >= b.x and l.x <= b.x+10) then
				b.sprite = 35
				b.alive = false
			end
		end

		-- cleanup lasers
		if(l.y < 0) then
			del(lasers, l)
		end
	end


	if(nbot2.alive == false) then
		print("game over", 45, 45)
		print("Press 'C' to try again", 20, 55)
	end		
	spr(nbot2.sprite, nbot2.x, nbot2.y)
end

function generate_badguys()
	num_badguys = 5
	start_col = rnd(100)

	for i=1,5 do
   	 -- add a bad guy
	 b = {}
	 b.x = start_col+(i*7)
	 b.y = -50
	 b.sprite = 20
	 b.alive = true

	 add(badguys, b)
 	end	
end

function move_ship()
	d = 4.4

	if(nbot2.alive == false) then
		if(btnp(4)) then
			game_init()
		end
		return
	end
	
	if(btnp(0)) then
		nbot2.x -= d
	end
	
	if(btnp(1)) then
		nbot2.x += d
	end
	
	if(btnp(2)) then
		nbot2.y -= d
	end
	
	if(btnp(3)) then
		nbot2.y += d
	end

	-- fire if required.
	if(btnp(4)) then 
		sfx(2)
		-- add a laser
		l = {}
		l.x = nbot2.x
		l.y = nbot2.y
		l.sprite = 57

		add(lasers, l)
	end
	
	if(btnp(5)) then
	 sfx(5)
	 -- add a super laser
	 l = {}
	 l.x = nbot2.x
	 l.y = nbot2.y
	 l.sprite = 60
	 
	 add(lasers, l)
	end
end

function game_init() 
	
	nbot2.x = 50
	nbot2.y = 100
	nbot2.sprite = 24
	nbot2.alive = true

	lasers = {} -- init lasers
	superlasers = {} -- init super lasers
	badguys = {} -- init bad guys
	t = 0

	-- for i=1,100 do
   	-- 	pset(rnd(100), rnd(100), 7)
 	-- end	
end
__gfx__
0000000000000000000c00000000000000cccc00000cc0000000000088000088cc0000cc8808808800cccc00cc0cc0cc888c0000000000000000000000000000
000000000005500000ccc0000008000000c00c0000cccc000008000088000088cc0000cc8808808800c00c00cc0cc0cc000c0000000000007000700000000000
00888800000550000c000c0000080000c0cccc0c00c00c000088800088000088cc0000cc8808808800c00c00cc0cc0cc808c0000000000000000000000000000
0088880050588505c00000c000080000c0cccc0c0cccccc00800080088000088cc0000cc8808808800cccc00cc0cc0cccccc0000000000007000070000000000
0000000055888855ccccccc000808000cccccccc0c0000c08888888088000088cc0000cc8808808800cccc00cc0cc0cc00000000000000000000000000000000
000000000555555000ccc00008898800c005500c0c0000c00088800088000088cc0000cc88088088cccccccccc0cc0cc80008000080088800000000000000000
00888800058558500c0c0c0088999880c059950c0c0000c00855580088000088cc0000cc88088088c099990ccc0cc0cc88808800888080800070000000000000
0088880000500500cc0c0cc000999000c009900c0c0000c08099908088000088cc0000cc88088088c099990ccc0cc0cc80808800080000800000700000000000
0000000000700000000000000000000000cccc0000000000000000000000000000000000000000000000000000000000086000d8000000880000000000000000
00070000000000000000000000000000c055550c0000000000000000808880800007000000000000088800000000000088000000000000000000000000000000
00000700000000000000000000000000c0c55c0c00000000000000008800088000717000000000008000800000000000098a9906000000000070000000000000
00000000700000000000000000000000ccc55ccc0000000000000000888888800071700000000000888880000000000009aaa900000000000000000000000000
00000000000000000000000000000000c0c55c0c00000000000000008888888007717700000000008888800000000000d99a9808000000000000000000000000
00000000000000000000000000000000c0cccc0c000000000000000080888080777777700000000088888000000000000899990d000000000007007000000000
00000000000000000000000000000000008888000000000000000000008080007077707000000000800080000000000000060000000000000000000000000000
0000000000070070000000000000000000cccc000000000000000000000000000088800000000000800080000000000099900060000000000000000000000000
000000000000000000000000d000000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080008005
000007000000000000000000008888000000000000000000000000000000000000000000000000000000000000bbcc0000000000000000000000000000500000
00700000000000000000000000899800000000088800000000000000000000000000000000000000000000000bbbccb000000000000000000000000050885550
0000000000000000000000000d8aa800000000088800888000000000000000000000000000070000000000000ccbbbb000000000000566000000000009988550
000000000000007000000000d0899800000000000800808800000000000000000000000000000000000000000ccbbbc000000000005665600000000008998550
0000000000000000000000000088880d000000000800888088000808088000880000000000000000000000000bbbbbb000000000006566600000000008988550
0000000700000000000000000d0000000000000808000000008008808008008000000000000000000000000000bbcc0000000000006655600000000000888550
00000000000000000000000000000d00000000008800000000000800800080880000000000000000000000000000000000000000000566000000000080500008
00000000000000000011000000000000000000000000000000008800000000000000000000000000aaaaaaaa0000000000888000000080000000000000000000
00000000070000001111110000000000000000000000000000000000000000000000000000880000aaaaaaaa0000000000888000008888800000000000000000
00000000070000001000010000000000000088880000000000088880000000000000000009999000aaaaaaaa0000000000888000008000800000000000000000
000000000ee000001111110000000000000080080000000008800080000000000000000008aa8000aaaaaaaa0000000000888000008888800000000000000000
00000000eeeeee001111110000000000000080080080000080000880080000000000000009999000aaaaaaaa0000000000888000088888880000000000000000
0000000000e00e001111110000000000000080088080800800088800088888000000000000880000aaaaaaaa0000000000888000089999980000000000000000
00000000000000008888880000000000000080080088800888880000080008000000000000880000aaaaaaaa0000000000888000089999980000000000000000
00000000000000008888880000000000000888080008800800000000080000000000000008888000aaaaaaaa0000000000888000080999080000000000000000
00000000000000000000000000000000000000880000000800000000080000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000888888000080000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000b00b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000bbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00baaaab000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b9999b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
00000000000000000000003a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0014142d00001414141400000014141400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00002b00000000000000000000002f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000141414141414000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0039393900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0039393900003c0000003c003c00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000003100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001d5501655013550145500f55014550141501c55001550065500b5500d5501555001550045501655008550255500e550185501b5501d5501c550155500f5500c5500a550115501a550161501415013150
00010000036500265002650046500665008650000000c6500f65012650146500f6500b6500665006650016500665006650000000d65005650116501365005650000002365008650276500365003650066500d650
000100001b050190501405012050110500e0500d0500d0500d0500f050110501305000000160501a050000001d0502005024050280502e05035050390503d050380502e050280502505024050240502405024050
0001000022750217502175021750217502175022750277502a7502e75033750397503e7503e7503975033750307502e7502d7502d7502c7502c7502d75030750377503f7503a7503075024750237502475025750
00010000163501635016350163501f3501f35021350233501f3502135021350233502335024350173501725015550155501355011550105501665014650236501f65016650166501665016650166501665016750
0001000001150041500b1500b150191500515022150231502315023150211501c1501d1501b1500515012550125501255012550125501255012550125501255012550125501455016100141000b1000110001100
00100000163501635016350163501635000000000001635000000000001935019350193501935019350193500000019350193501935018350183501835018350183501835018350233503f350273502f35038350
0010000000000145501455014550145501455014550115500f5500f5500f5501055014550165501555014550115500e55009550075500b5500f550145501a5500d50000000000001350000000000000000013500
001000000000000000000000b5500b5500b5500b5500b5500b550000000c550000000000000000000000c55000000000000c5500000000000000000c5500000000000000000c5500000009550075500555004550
00100000000000475005750077500875009750000000b750000000e750000001375000000000001775019750000001d7501f750000002175022750227502275022750227502275023750207501b7501875015750
00100000136501d670296102a6001860006600026003360022600126000c600066000560002600016000c5000b5000a50014500095000b5000850007500015000650004500045000350002500000000000000000
__music__
00 01424344

