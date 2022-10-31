pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
--crillion
-- by gpi

--[[ todo

-version 1.02
- ❎ - speed up temporary
- 🅾️ - lock the ball in the column
- better collision-detection-logik, when a ball hits a block/disc and recolor-block
- move the start-position of the ball slidgly to the side since 2 pixel-movement is difficult
- bugfix warp-wait after all blocks are destroyed was depending on gamespeed
- disc-movment-speed is now affected by gamespeed
- black border around the ball over particels
- particels dim now
- skip level-option in pause menu for training
- crillion lvl 18,21 - bugfix
- crillion lvl 6 - bugfix
- crillion ii lvl 5,6,14,19 - bugfix
- new episode: jUNIOR - form crillion junior by holy moses

-version 1.01
- correct "tHe" to "tHE"
- correct minor collision-detection bug

--]]

cartdata("4bd3ff36-582c-11ed-9b6a-0242ac120002_crillion")

offsetfield = 16*3
leveladr = 0x1300
episodename=split("cRILLION,cRILLION '93,cRILLION 2,bRAINION,jUNIOR")
episodedesigner=split("oLIVER kIRWA,oLIVER kIRWA,oLIVER kIRWA,tHE jOKER & dR. gURU (dt #104),HOLY MOSES")
modename = {training="tRAINING",score="hi-sCORE"}
speedname=split("lIGHTSPEED,nORMAL,sLOW,sLEEPING")
chartable = split("a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z, ,.,♥,🐱,★,●,◀,き")-- + back +end

dimcolor={[4] = split("1,2,3,4,5, 6, 7,8,9,10,11,12,13,14,15,0"),
										[3] = split("1,2,3,2,5,13, 6,8,4, 9, 3,16, 5, 4, 6,0"),
										[2] = split("0,1,1,2,1, 5,13,2,4, 5, 3, 1, 1, 2, 5,0"),
          [1] = split("0,0,0,0,0, 1, 1,0,1, 1, 1, 1, 1, 1, 1,0")}
for i=1,#dimcolor do
	dimcolor[i][0] = dimcolor[i][16]
end          

function find(table,what)
	for nb,value in pairs(table) do
 	if value == what then
  	return nb
  end
 end
 return 0
end
  



function _init()
	cls()
	?"\^@5f560002▮▮" -- map settings 16 width, 0x1000 start
 -- font
 ?"\^@5f580001▒\^@56000800⁴⁵⁷\0\0¹\0\0\0\0\0\0\0`w\0g \0aw\0⁶⁶\0\0\0\0\0fw⁷¹\0\0\0`⁷'\0\0\0\0 \0pp\0\0\0¹▮`\0 ■▮\0▮!\0\0⁶q33⁙■⁙3□⁙3⁙33■133R\0qu⁷▶7wwfvPf▶□sw⁷w¹wwfw¹w⁷w¹\0p\0w⁷w¹wwfw\0\0\0p¹\0pp\0⁷⁷⁷⁷⁷\0\0\0\0⁷⁷⁷\0\0\0\0\0⁷⁵⁷\0\0\0\0\0⁵²⁵\0\0\0\0\0⁵\0⁵\0\0\0\0\0⁵⁵⁵\0\0\0\0⁴⁶⁷⁶⁴\0\0\0¹³⁷³¹\0\0\0⁷¹¹¹\0\0\0\0\0⁴⁴⁴⁷\0\0\0⁵⁷²⁷²\0\0\0\0\0¹\0\0\0\0\0\0\0\0¹²\0\0\0\0\0\0³³\0\0\0⁵⁵\0\0\0\0\0\0²⁵²\0\0\0\0\0\0\0\0\0\0\0\0\0¹¹¹\0¹\0\0\0⁵⁵\0\0\0\0\0\0\n゜\n゜\n\0\0\0²⁷³⁶⁷²\0\0⁵⁴²¹⁵\0\0\0²⁵ᵉ⁵ᵉ\0\0\0¹¹\0\0\0\0\0\0²¹¹¹²\0\0\0¹²²²¹\0\0\0⁵²⁷²⁵\0\0\0\0²⁷²\0\0\0\0\0\0\0\0¹¹\0\0\0\0⁷\0\0\0\0\0\0\0\0\0¹\0\0\0⁴⁴²¹¹\0\0\0²⁵⁵⁵²\0\0\0²³²²⁷\0\0\0³⁴²¹⁷\0\0\0³⁴²⁴³\0\0\0⁵⁵⁷⁴⁴\0\0\0⁷¹³⁴³\0\0\0⁶¹³⁵²\0\0\0⁷⁴⁴²²\0\0\0²⁵²⁵²\0\0\0²⁵⁶⁴³\0\0\0\0¹\0¹\0\0\0\0\0\0¹\0¹¹\0\0\0²¹²\0\0\0\0\0³\0³\0\0\0\0\0¹²¹\0\0\0\0³⁴²\0²\0\0\0⁶\t\r¹⁶\0\0\0\0³⁶⁵⁷\0\0\0¹³⁵⁵³\0\0\0\0⁶¹¹⁶\0\0\0⁴⁶⁵⁵⁶\0\0\0\0²⁵³⁶\0\0\0⁴²⁷²²\0\0\0\0⁶⁵⁶⁴³\0\0¹¹³⁵⁵\0\0\0¹\0¹¹¹\0\0\0²\0²²²¹\0\0¹⁵³⁵⁵\0\0\0¹¹¹¹²\0\0\0\0ᶠ‖‖‖\0\0\0\0³⁵⁵⁵\0\0\0\0²⁵⁵²\0\0\0\0³⁵⁵³¹\0\0\0⁶⁵⁵⁶⁴\0\0\0³⁵¹¹\0\0\0\0⁶³⁶³\0\0\0²⁷²²⁶\0\0\0\0⁵⁵⁵²\0\0\0\0⁵⁵⁵³\0\0\0\0■■‖\n\0\0\0\0⁵²⁵⁵\0\0\0\0⁵⁵⁵⁶³\0\0\0⁷⁶³⁷\0\0\0³¹¹¹³\0\0\0¹²²²⁴\0\0\0³²²²³\0\0\0²⁵\0\0\0\0\0\0\0\0\0\0⁷\0\0\0²⁴\0\0\0\0\0\0³⁴⁷⁵⁵\0\0\0³⁴³⁵³\0\0\0⁶¹¹¹⁶\0\0\0⁷\t\t\t⁷\0\0\0⁷\0⁷¹⁷\0\0\0⁷¹³¹¹\0\0\0ᵉ¹\r\t⁶\0\0\0⁵⁵⁷⁵⁵\0\0\0¹¹¹¹¹\0\0\0⁴⁴⁴⁴⁵²\0\0⁵⁵³⁵⁵\0\0\0¹¹¹¹⁷\0\0\0■•‖■■\0\0\0\tᵇᶠ\r\t\0\0\0⁶\t\t\t⁶\0\0\0³⁴³¹¹\0\0\0⁶\t\t\r⁶⁸\0\0³⁴³⁵⁵\0\0\0⁶¹²⁴³\0\0\0⁷²²²²\0\0\0\t\t\t\t⁶\0\0\0\t\t\t⁵³\0\0\0■■‖•■\0\0\0⁵⁵²⁵⁵\0\0\0⁵⁵²²²\0\0\0⁷⁴²¹⁷\0\0\0⁶²¹²⁶\0\0\0¹¹\0¹¹\0\0\0³²⁴²³\0\0\0\0\0\n⁵\0\0\0\0³³\0\0\0\0\0\0○○○○○○\0\0U*U*U*\0\0A○]]>\0\0\0>ccw>\0\0\0■D■D■D\0\0²゛ᵉᶠ⁸\0\0\0ᵉ▶゜゜ᵉ\0\0\0•゜゜ᵉ⁴\0\0\0、6w6、\0\0\0ᵉᵉ゜ᵉ\n\0\0\0、>○*:\0\0\0>gcg>\0\0\0?-?!?\0\0\0、⁴⁴⁷⁷\0\0\0>ckc>\0\0\0⁴ᵉ゜ᵉ⁴\0\0\0\0\0U\0\0\0\0\0>scs>\0\0\0⁸、○>\"\0\0\0゜ᵉ⁴ᵉ゜\0\0\0>wcc>\0\0\0\0⁵R \0\0\0\0\0■*D\0\0\0\0>kwk>\0\0\0゜\0゜\0゜\0\0\0‖‖‖‖‖\0\0⁴ᵉ゜\0\0\0\0\0002U7T3\0○\0b‖▶⁘c\0○\0002UWT3\0○\0r‖w⁘s\0○\0r‖w⁘⁙\0○\0²⁵⁵²(「(\0\0\0¹\0¹¹¹\0\0\0⁴ᵉ⁵ᵉ⁴\0\0ᶜ²⁷²ᶠ\0\0\0■ᵉ\nᵉ■\0\0⁵⁵²⁷²\0\0\0\0¹¹\0¹¹\0\0\0⁶³⁵⁶³\0\0⁵\0\0\0\0\0\0\0⁶\t\r\t⁶\0\0\0\0³⁶⁵⁷\0\0\0\0\0□\t□\0\0\0\0\0\0⁷⁴\0\0\0002UWU5\0○\0³⁵³⁵\0\0\0\0\0⁷\0\0\0\0\0\0\0²⁵²\0\0\0\0\0²⁷²\0⁷\0\0³²¹³\0\0\0\0¹³²¹\0\0\0\0\0²¹\0\0\0\0\0\0\0\0⁵⁵³¹\0\0ᶠᵇᵇ\n\n\0\0\0\0\0¹\0\0\0\0\0\0\0\0\0²³\0²³²²\0\0\0\0²⁵²\0\0\0\0\0\0\0\t□\t\0\0\0\0■\t⁵*9 \0\0■\t。□\t「\0\0!⁙\nUr@\0\0\0²\0²¹⁶\0²⁴³⁶⁵⁷\0\0²¹³⁶⁵⁷\0\0²⁵³⁶⁵⁷\0\0\n⁵³⁶⁵⁷\0\0⁵\0³⁶⁵⁷\0\0²\0³⁶⁵⁷\0\0\0\0ᵇ◀\r゜\0\0\0\0\0ᵉ¹ᵉ⁴\0²⁴²⁵³⁶\0\0²¹²⁵³⁶\0\0²⁵²⁵³⁶\0\0⁵\0²⁵³⁶\0\0¹²\0\0²²\0\0²¹\0\0¹¹\0\0²⁵\0\0²²\0\0⁵\0\0\0²²\0\0\0ᵉ□▶□ᵉ\0\0\n⁵\0⁷\t\t\0\0¹²\0²⁵²\0\0⁴²\0²⁵²\0\0²⁵\0²⁵²\0\0\n⁵\0⁶\t⁶\0\0⁵\0\0²⁵²\0\0\0\0⁵²⁵\0\0\0\0▮ᵉ‖□\r\0\0²⁴\0\t\t⁶\0\0⁴²\0\t\t⁶\0\0⁶\t\0\t\t⁶\0\0\t\0\0\t\t⁶\0\0⁴²\0⁵⁵⁶³\0\0¹⁵ᵇᵇ⁵¹\0\0⁶\t⁵\t⁵\0\0²⁴²⁵⁷⁵\0\0²¹²⁵⁷⁵\0\0²⁵²⁵⁷⁵\0\0\n⁵⁶\tᶠ\t\0\0⁵\0²⁵⁷⁵\0\0²\0²⁵⁷⁵\0\0\0゛⁵ᶠ⁵。\0\0\0ᵉ¹¹¹ᵉ⁴\0²⁴⁷³¹⁷\0\0²¹⁷³¹⁷\0\0²⁵⁷³¹⁷\0\0⁵\0⁷³¹⁷\0\0¹²\0²²²\0\0²¹\0¹¹¹\0\0²⁵\0²²²\0\0⁵\0\0²²²\0\0²⁵ᵉ\t\t⁶\0\0\n⁵\tᵇ\r\t\0\0²⁴⁶\t\t⁶\0\0⁴²⁶\t\t⁶\0\0²⁵⁶\t\t⁶\0\0\n⁵⁶\t\t⁶\0\0\t\0⁶\t\t⁶\0\0\0²\0⁷\0²\0\0\0◀\t‖□\r\0\0²⁴\t\t\t⁶\0\0⁴²\t\t\t⁶\0\0²⁵⁸\t\t⁶\0\0\t\0\t\t\t⁶\0\0⁴²⁵⁵²²\0\0\0¹⁷\t\t⁷¹\0⁵\0⁵⁵²²\0\0"
 
	read_leveldata()
 
 load_settings()
 handle = "title"
 --[[
 episode = 1--4
 level = 1--25
 mode = "training"
 gamespeed = 1
 --]]
 pixeldeath = 0
 
	selection = 3
 
end


anim = 0 
anim_phase = 0

anim_warp = split("48,49,50,51,-50,-49,-48")
anim_explosion = split("52,53,54,55")
anim_wink = split("1,1,1,4,4,4,5,5,5,4,4,4,1,1,1")
anim_group = 0

function change_handle(str)
	handle=str
 anim_phase = 0
 anim_group = 0
end
 

function _update60()
 anim +=1
 if handle == "title" then
 	selection = 4 -- start  
  selectiony = -100
  selectiony2 = -100
  selectioncol = 2
  change_handle("dotitle")
 end

	if handle == "dotitle" then
  if btnp(⬆️) then
  	selection -=1
  elseif btnp(⬇️) then
  	selection +=1
  end
  selection = selection % 5
  
  if btnp(⬅️) then
  	if selection == 0 then
   	episode = (episode -2)% #leveldata +1
   elseif selection == 1 then
   	mode = (mode=="training" and "score" or "training")
   elseif selection == 2 then
   	level = (level -2) % #leveldata[episode] +1
   elseif selection == 3 then
   	gamespeed = (gamespeed -1 ) % 4
   end
  elseif btnp(➡️) then
  	if selection == 0 then
   	episode = (episode )% #leveldata +1
   elseif selection == 1 then
   	mode = (mode=="training" and "score" or "training")
   elseif selection == 2 then
   	level = (level ) % #leveldata[episode] +1
   elseif selection == 3 then
   	gamespeed = (gamespeed +1 ) % 4
   end
  
  end
  
  if btnp(❎) or btnp(🅾️) then
  	if selection == 4 then
   	change_handle("loadlevel")
    save_settings()
    lives = 5
    score = 0
    startlevel = level
    memcpy(0x8000,0x6000,0x2000)
   end
  end
   
  
 
	elseif handle == "loadlevel" then
 	load_level()
  change_handle("morphlevel")
  
 elseif handle == "morphlevel" then
 	if anim_group >= 1 then
   change_handle("waitlevel")
  end
  
 elseif handle == "waitlevel" then
 	if btn() == 0 and not waitbtnclear then
  	waitbtnclear = true
  elseif btn()&63 != 0 and waitbtnclear then
  	waitbtnclear = false
   change_handle("warpinlevel")
  end
  
 elseif handle == "warpinlevel" then
 	if anim_group >= 1 then
  	change_handle("playgame")
   button = nil
   balldx = 0
   balldy = 1
   waitwarp = 3*8
   if mode == "training" then
	   menuitem(5,"skip",
 	  	function() bonus=0 blocks=0 end)
   end
   menuitem(3,"self-destruction",
   	function() balldeath = true end)
   menuitem(4,"back to main",
   	function() balldeath = true lives = 0 end)
  end
  
 elseif handle == "playgame" then
 	if btn(⬅️) then button = ⬅️ end
  if btn(➡️) then button = ➡️ end
  
  
  if gamespeed == 0 or btn(❎) then
  	gamelogic()
   gamelogic()
  elseif anim % gamespeed == 0 then
  	gamelogic()   
	 end
  
  if balldeath == true then
  	change_handle("balldeath")
   wait = 60
  end
  
  if blocks <= 0 and waitwarp <=0 then
  	change_handle("leveldone")
   wait = 60   
  end
 
 elseif handle == "leveldone" then
 	if anim_group >= 1 and #movingpixels == 0 then
  	if bonus > 0 then
   	bonus \=1
    if bonus \ 100 > 0 then
    	bonus -= 100 
     score += 100
    end
    if (bonus%100) \10 > 0 then
    	bonus -= 10
	    score += 10
    end
    if (bonus%10) > 0 then
    	bonus -= 1
     score +=1
    end
   else
	  	wait -=1 
	   if wait <=0 then
	   	memcpy(0x8000,0x6000,0x2000)
		  	level += 1
     if level > #leveldata[episode] then
     	change_handle("gameover")
     else
			   change_handle("loadlevel")
     end
	    menuitem(5)
     menuitem(4)
     menuitem(3)
	   end
   end
  end
 
 elseif handle == "balldeath" then
 	if anim_group >= 2 and #movingpixels == 0 then
  	wait -=1
  	if wait <= 0 then
   	memcpy(0x8000,0x6000,0x2000)
    menuitem(4)
    menuitem(5)
    menuitem(3)
    if mode != "training" then
	    lives -= 1
    end
    if lives <= 0 then
    	change_handle("gameover")
    else     	
     change_handle("loadlevel")
    end

   end
  end
 
 elseif handle == "gameover" then
 	change_handle("morphgameover")
  selchar = 1
  name = ""
  if lives>0 then
	  score += lives * 100
  end
  level = startlevel
  
 elseif handle == "morphgameover" then
		if btn() == 0 and not waitbtnclear then
  	waitbtnclear = true
  elseif btn()&63 != 0 and waitbtnclear then
  	waitbtnclear = false
  end
  
	 if anim_group >= 1 and waitbtnclear then 
			change_handle("dogameover")
	 end
  
 elseif handle == "dogameover" then
 	if score > leveldata[episode].hiscore[3].score and mode == "score" then
   if btnp(⬅️) then
   	selchar = (selchar-2) % #chartable +1
   elseif btnp(➡️) then
   	selchar = (selchar) % #chartable +1
   end
   if #name >= 3 then
   	if chartable[selchar] != "◀" and chartable[selchar] != "き" then
	   	selchar = find(chartable,"き")
	   end
   end
   
   if btnp(❎) or btnp(🅾️) then
   	if chartable[selchar] == "◀" then
    	name=sub(name,1,-2)
    elseif chartable[selchar] == "き" then
    	name=sub(name.."   ",1,3)
   	 change_handle("morphtitle")
     leveldata[episode].hiscore[3].score = score
     leveldata[episode].hiscore[3].name = name
     save_settings()
     memcpy(0x8000,0x6000,0x2000)
    elseif #name < 3 then
    	name ..= chartable[selchar]
    end   
   end
   
  else
  	if btnp(❎) or btnp(🅾️) then
   	 change_handle("morphtitle")
     memcpy(0x8000,0x6000,0x2000)
   end
  end    
  
 elseif handle == "morphtitle" then
 	if anim_group >= 1 then 
			change_handle("title")
	 end
 end
 
end



function _draw()
 cls()
 if handle == "gameover" then
 	memcpy(0x6000,0x8000,0x2000)
 
 elseif handle == "dogameover" then
 	draw_gameover() 
 
 elseif handle == "dotitle" or handle == "title" then  
  draw_title()
  
 elseif handle == "loadlevel" then
 	memcpy(0x6000,0x8000,0x2000)
  
 elseif handle == "morphlevel" or handle == "morphgameover" or handle == "morphtitle" then
 	if handle == "morphlevel" then
	 	draw_level()
  elseif handle == "morphgameover" then
   draw_gameover()
  else
   draw_title()
  end
  
  local size = (4- anim_phase\1) * 16 * 4
  for y = 0, 31 do
  	local delta = y * 16*4*4 + anim_phase\1 * 16*4
  	memcpy(0x6000+delta, 0x8000+delta, size)  
  end 
  
  if anim_phase < 4 then
  	anim_phase +=0.25
  else
  	anim_group +=1
  end
 
	elseif handle == "waitlevel" then
		draw_level()
		if anim_phase > 0 then
	  sprite( anim_warp[anim_phase\1],ballx,bally) 
	  if anim_phase >= #anim_warp then
	  	anim_phase=-60
	  else
	  	anim_phase+=0.25
	  end
		else
			anim_phase+=1
		end
  
 elseif handle == "warpinlevel" then
 	draw_level()
  anim_phase+=1
  if anim_phase == 1 then
  	sfx(64)
  end
  if anim_phase >= #anim_warp\2 then
  	ballvis = true
  end
  sprite( anim_warp[anim_phase\1],ballx,bally)
  
  if anim_phase >= #anim_warp then
  	anim_group += 1
  end
		
	elseif handle == "playgame" then
  draw_level()  
  
 elseif handle == "leveldone" then
 	draw_level()
  anim_phase+=1
  if anim_phase == 1 then
  	sfx(64)
  end
  if anim_phase >= #anim_warp\2 then
  	ballvis = false
  end
  sprite( anim_warp[anim_phase\1],ballx,bally)

  if anim_phase >= #anim_warp then
  	anim_group += 1
  end
  
 elseif handle == "balldeath" then
 	
  
  if anim_group == 1 then -- wink
  	if #movingpixels <=0 then
  		anim_phase +=1 
	  	if anim_phase <= #anim_wink then
		  	for y=offsetfield, offsetfield+11 do
		   	for x=0, 15 do
		    	local char = mget(x,y)
		     if char == 1 or char == 4 or char == 5 then
	      	mset(x,y, anim_wink[anim_phase])
		     end
		    end
		   end
	   else
	   	anim_group = 2
	   end
   end
  end
  
 	draw_level()
  
  if anim_group == 0 then --explosion
  	anim_phase +=1
  	if anim_phase == 1 then
   	sfx(60)
    for i = 0, 300 do
   		add(movingpixels,
     	{col=127,x=ballx+4,y=bally+4,
      	dx = cos(i/300)*(1+rnd(2)), 
       dy = sin(i/300)*(1+rnd(2)),
       live=30+rnd(20)\1
      }
     )
    end    
   end
	  if anim_phase <= #anim_explosion then
   	sprite(anim_explosion[anim_phase],ballx, bally)
    ballvis = false
   else
   	anim_phase = 0 
    anim_group = 1
   end
  end
   
   
 else
 	--draw_level() 
 	printh(handle.." "..tostr(anim_group))
 end
 
 if sound_ref then
 	sfx(sound_ref)
  sound_ref=nil
 end
 if sound_splitter then
 	sfx(sound_splitter)
  sfx(62)
  sound_splitter=nil
 end
 if sound_change then
 	sfx(sound_change)
  sound_change = nil
 end
 if sound_disc then
 	sfx(sound_disc)
  sound_disc=nil
 end
 
end
-->8
--bits
function bitspos(adr)
	_bitsadr = adr
 _bitsbit = 1
end

function bits(size,b)
	local ret = 0
 for i = 0, size - 1 do
  if b then
   poke(_bitsadr, peek(_bitsadr) & ~(_bitsbit * (~b&1)) | (b&1) * _bitsbit)
   b >>>= 1
  else
  	ret |= peek(_bitsadr) & _bitsbit != 0 and 1 << i or 0
  end
  _bitsadr +=  _bitsbit \ 128
  _bitsbit = (_bitsbit << 1) % 255	
 end
 return ret
end


-->8
--levels

function read_leveldata()
	leveldata = {}
	bitspos(leveladr)
	for nb = 1, #episodename do
 	local levels = {index = #leveldata+1}
  repeat
  	local x,y = bits(4), bits(4)
   if x==0 and y==0 then break end
   local col = bits(3)
   local dat = {ballx=x, bally=y, ballcol=col, field={},index = #levels+1}
   local count = 15*11 
   while count > 0 do
   	local what = bits(3)
    if what == 0 then -- empty
    	add(dat.field,0x00)
     count-=1
    elseif what == 1 then -- skull
    	add(dat.field,0x01)
     count-=1
    elseif what == 2 then -- stone
	  		add(dat.field,0x02)
     count-=1
    elseif what == 3 then -- block
    	add(dat.field,0x10 + col)
     count-=1
    elseif what == 4 then -- disc
    	add(dat.field,0x18 + col)
     count-=1
    elseif what == 5 then -- changer
    	add(dat.field,0x20 + col)
     count-=1
    elseif what == 6 then -- color
    	col = bits(3)
    elseif what == 7 then -- repeat
     local char = dat.field[#dat.field]
     for i = 1, bits(3) + 3 do
      add(dat.field, char)
      count-=1
     end
    end
   end
   add(levels,dat)
  until(false)
  add(leveldata, levels)
 end
 memset(leveladr,0x00,0x1d00)
end
   
function load_level()
	memset(leveladr,0x00,16*16)
 blocks = 0
 local nb = level
 if nb > #leveldata[episode] then
 	nb = rnd(#leveldata[episode])\1+1
 end
 
 local lev = leveldata[episode][nb]
 for i = 0, 15*11-1 do
 	mset(i%15,i\15+offsetfield,lev.field[i+1])
  if lev.field[i+1] >= 16 and lev.field[i+1] <= 23 then
  	blocks +=1
  end
 end
 ballx = lev.ballx * 8 - 6+ (lev.ballx >=7 and 4 or 0)-- 4
 bally = lev.bally * 8 - 6
 ballcol = lev.ballcol
 ballvis = false
 balldeath = false
 bonus=999
 bonuscol = -1
 bonuspoint = 1
 movingdisc={}
 movingpixels={}
end

spacer = 1
lspacer = 0



-->8
--settings
function load_settings()
	bitspos(0x5e00)
 episode = bits(4)
 level = bits(5)
 mode =  bits(1)==0 and "training" or "score"
 gamespeed = bits(2)
 
 if episode == 0 and level == 0 then
 	episode = 1
  level = 1
 	gamespeed = 1
  mode = "score"
  for epi=1,#leveldata do
	  local hiscore={}
	  for top = 1,3 do
		 	add(hiscore,{name="gpi", score=4000-top*1000})
	  end
	  leveldata[epi].hiscore = hiscore
	 end
  return
 end

 gamespeed = mid(gamespeed,0,3)
 episode = mid(episode,1,#leveldata)
 level = mid(level,1,#leveldata[episode])

 for epi=1,#leveldata do
  local hiscore={}
  for top = 1,3 do
	 	local str = ""
	  for c=1,3 do
	  	str..=chartable[bits(5)+1]
	  end
   score =bits(16)
   if str == "aaa" and score == 0 then str="gpi" score = 4000-top*1000 end
	  add(hiscore,{name=str, score=score})
  end
  leveldata[epi].hiscore = hiscore
 end
end

function save_settings()
	bitspos(0x5e00)
 bits(4,episode)
 bits(5,level)
 bits(1,mode=="training" and 0 or 1)
 bits(2,gamespeed)
 
 for epi=1,#leveldata do
 	for a=1,2 do
  	for b=a+1,3 do
   	if leveldata[epi].hiscore[a].score < leveldata[epi].hiscore[b].score then
    	leveldata[epi].hiscore[a],leveldata[epi].hiscore[b] = leveldata[epi].hiscore[b],leveldata[epi].hiscore[a]
 			end
   end
  end
 
 	for top = 1, 3 do
  	for c=1,3 do
   	bits(5, find(chartable, sub(leveldata[epi].hiscore[top].name,c,c))-1)    
   end
   bits(16,leveldata[epi].hiscore[top].score)
  end
 end
end
-->8
--paint

function sprite(nb,x,y)
	if nb then
		spr(abs(nb), x, y,1,1, nb<0)
 end
end

yprint = 0
function cprint(str,col)
	local x = print(str,0,-20)
 print(str,64-x\2,yprint,col or 7)
 return 64+x\2,64-x\2
end

function rprint(str,col,x,y)
	local cx = print(str,0,-20)
 print(str,(x or 128)-cx,y or yprint,col or 7)
 return (x or 128) - cx
end

function lprint(str,col,x,y)
	return print(str,(x or 0),y or yprint, col or 7)
end
-->8
--draw
function draw_gameover()
	map(0,32)
 yprint = 3*8+4
 
 cprint("\^w\^ttHE tOP tHREE",10) yprint+=14
 cprint(episodename[episode],4) yprint+=7+4
 
 for top=1,3 do
 	lprint(leveldata[episode].hiscore[top].name,9,34)
  rprint(leveldata[episode].hiscore[top].score,9,94)
  yprint+=7
 end
 
 score \=1
 yprint+=8
 cprint("yOUR SCORE:",5) yprint+=7
 cprint("\^w"..score,6) yprint+=7
 yprint+=4
 if score > leveldata[episode].hiscore[3].score and mode == "score" then
 		cprint("eNTER YOUR NAME:",7) yprint+=7
   cprint("\^w"..name,10) yprint+=7+4
   
   local x2,x1 = cprint("\^w"..chartable[selchar],8)
   local c=selchar
   while x1 > 0 do
    c = (c-2)% #chartable + 1
    x1 = rprint(chartable[c],2,x1-4)
   end
   c=selchar
   while x2 < 128 do
    c = c% #chartable + 1
    x2 = lprint(chartable[c],2,x2+4)
   end    
   yprint+=8
   cprint("あ")
 end
 
end

function draw_title()
	episode = mid(1,#leveldata,episode)
 level = mid(1,#leveldata[episode],level)
 
	map(0,16)
 yprint = 3*8-5
 rprint("BY gpi",1) yprint+=7
 --rprint("oRIGINAL BY oLIVER kIRWA",1) yprint+=7
 
 rectfill(0,selectiony,128,selectiony2,selectioncol)
 
 yprint +=4  
 cprint("tHE tOP tHREE",10) yprint+=7
 --rprint("abc",9,44) lprint("65535",9,84) yprint+=7
 --rprint("abc",9,44) lprint("65535",9,84) yprint+=7
 --rprint("abc",9,44) lprint("65535",9,84) yprint+=7
 for top=1,3 do
 	lprint(leveldata[episode].hiscore[top].name,9,34)
  rprint(leveldata[episode].hiscore[top].score,9,94)
  yprint+=7
 end
 
 yprint+=8

 local desty = yprint  
 if selection == 0 then desty = yprint end
 rprint("ePISODE:",6,42)
 lprint("\^w"..episodename[episode],(selectioncol==8 and selection==0) and 15 or 7,46)
 yprint +=7
 cprint(episodedesigner[episode],5)
 yprint +=7+4
 
 if selection == 1 then desty = yprint end
 rprint("mODE:",6,42)
 lprint("\^w"..modename[mode],(selectioncol==8 and selection==1) and 15 or 7,46)
 yprint +=7+4
 
 
 if selection == 2 then desty = yprint end
 rprint("lEVEL:",6,42)
 lprint("\^w"..tostr(level),(selectioncol==8 and selection==2) and 15 or 7,46)    
 yprint +=7+4

	if selection == 3 then desty = yprint end
 rprint("sPEED:",6,42)
 lprint("\^w"..speedname[gamespeed+1],(selectioncol==8 and selection==3) and 15 or 7,46)    
 yprint +=7+8
 
 if selection == 4 then desty = yprint end
 cprint("\^wsTART",7)
 
 if selectiony<0 or abs(selectiony-desty)<1 then
 	selectiony = desty
 else
 	selectiony += (desty-selectiony)/10
 end
 if selectiony2<0 or abs(selectiony2-desty-7)<1 then
 	selectiony2 = desty+7
 else
 	selectiony2 += (desty+7-selectiony2)/3
 end
 if selectiony == desty and selectiony2 == desty+7 then
 	selectioncol = 8
 else
  selectioncol = 2
 end
end

function draw_level()
	-- background
	map()
 clip(4,4,15*8,11*8)
 -- shadow
	pal(split("0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"))
 map(0,offsetfield,8,8)
 if ballvis then
 	spr(8 + ballcol, ballx+4, bally+4)
 end
 for nb,disc in pairs(movingdisc) do
 	spr(disc.char, disc.x+4,disc.y+4)
 end
 -- playfield
 pal()
 --pixels
 local doborder
 spl={} 
 spldone={}
 for nb,pixel in pairs(movingpixels) do
 	pixel.live-=1
  if pixel.live>pixeldeath then
  
  		local off,c = 1
  		if pixel.live > 15 then
    	off=4
    elseif pixel.live >10 then
    	off=3
    elseif pixel.live >5 then
    	off=2
    end
  
  		if pixel.col < 16 then
  			c = dimcolor[off][pixel.col]
    else
     c = dimcolor[off][5+rnd(2)\1]
    end

    if c == 0 then
	    	del(movingpixels,pixel)
    else
     pset(pixel.x,pixel.y, c)
    
    
	    if abs(pixel.x-ballx-3.5)< 4 and abs(pixel.y-bally-3.5)<4 then
	    	doborder = true
	    end
	    
	    local bx,by = (pixel.x+pixel.dx-4)\8, (pixel.y-4)\8
	    if (bx<0 or by<0 or bx>=15 or by>=11) or mget(bx,by+offsetfield)!=0 then
	    	if pixel.col>16 and mget(bx,by+offsetfield)>=16 and mget(bx,by+offsetfield)<=23 then
	     	if not spldone[bx.."x"..by] then
		      spldone[bx.."x"..by] = true
		      add(spl,{bx=bx,by=by,px=pixel.x,py=pixel.y})
		      del(movingpixels,pixel)
	      end
	     else
		    	pixel.dx = -pixel.dx *0.8
	     end
			  end  
	    pixel.x+=pixel.dx
				 bx,by = (pixel.x-4)\8, (pixel.y+pixel.dy-4)\8
	    if (bx<0 or by<0 or bx>=15 or by>=11) or mget(bx,by+offsetfield)!=0 then
		    if pixel.col>16 and mget(bx,by+offsetfield)>=16 and mget(bx,by+offsetfield)<=23 then
	     	if not spldone[bx.."x"..by] then
		      spldone[bx.."x"..by] = true
		      add(spl,{bx=bx,by=by,px=pixel.x,py=pixel.y})
		      del(movingpixels,pixel)
	      end 
	     else
		    	pixel.dy = -pixel.dy *0.8
	     end
     end
		  end      
    pixel.y+=pixel.dy
  else
   	del(movingpixels,pixel)
  end
  
  --(bx-4+2)\8, (by-4+2)\8  
 end
 
 pal()

 if ballvis and doborder then
  palt(0B0100000000000000)
  spr(7,ballx,bally)
  palt()
 end
 
	-- blocks
 map(0,offsetfield,4,4)
      
 if ballvis then
 	spr(8 + ballcol, ballx, bally)
 end

 for nb,s in pairs(spl) do
	 create_splitter(s.bx,s.by,s.px,s.py)
	 sound_splitter = 24 + mget(s.bx,s.by+offsetfield) - 16
	 mset(s.bx,s.by+offsetfield,0)
 end  
  
 for nb,disc in pairs(movingdisc) do
 	spr(disc.char, disc.x,disc.y)
 end
 clip()
 
 local x,y=0,100
 
 rectfill(0,y,128,y+4,1)
 if bonus\1 > 0 then
  x=126/999*bonus
	 rectfill(1,y+1,1+x,y+3,12)
 end
 
 y+=4+4
 x=lspacer
 
 lprint(sub("00000"..score\1,-5),11,x+8,y+7)
 x=lprint("sCORE:",3,x,y) + spacer
 
 lprint(sub("00"..level,-2),11,x+8,y+7)
 x=lprint("lEVEL:",3,x,y)+spacer
 
 lprint(sub("00"..blocks,-2),11,x+8,y+7)
 x=lprint("bLOCKS:",3,x,y)+spacer

 lprint(mode == "training" and "ヲ" or lives,11,x+8,y+7)
 x=lprint("lIVES:",3,x,y)

 spacer += (128-x+lspacer)\3
 lspacer = (128-x+lspacer)\2
 
 
 --anim disc
 --{char=char, mx=mx2,my=my2,dx=dx,dy=dy,c=8, x=mx*8+4, y=my*8+4}

end


function create_splitter(mx,my,cx,cy)
	for y =my*8+4,my*8+4+7 do
	 for x = mx*8+4,mx*8+4+7 do
  	add(movingpixels,{col=pget(x,y),x=x,y=y,dx = (x-cx)/8 +rnd(1)-0.5, dy = (y-cy)/8+rnd(1)-0.5,live=rnd(22)\1+13})
  end
 end
end

-->8
--gameplay

function ball_col(bx,by,dx,dy)
	bx+=dx
 by+=dy
 local	check = function(mx,my)
		if mx<0 or my<0 or mx>=15 or my>=11 then
  	sound_ref = 61
  	return true -- collision level-wall
  end
  local char,sym,col = mget(mx,my+offsetfield)
  if char == 1 then
 		balldeath = true -- skull
   
  elseif char == 2 then 
	  sound_ref = 61-- stone
   
  elseif char >= 16 and char <= 23 then
  	sym=3 -- block
   col = char-16
   
  elseif char >= 24 and char <= 31 then
  	sym=4 -- disc
   col = char-24
   
  elseif char >= 32 and char <= 39 then  	
   col = char-32-- recolor
   collisioncol[col] = true
   ballcol = col
   sound_change = 40+col
  end	  
  
  if sym then
	  collision[mx.."x"..my]={mx=mx,my=my,dx=dx,dy=dy,sym=sym,col=col}
  end
  return char != 0 
 end
 
 local a1,a2,a3,a4 = check((bx-4+2)\8, (by-4+2)\8) 
  , check((bx-4+2+3)\8, (by-4+2)\8) 
  , check((bx-4+2+3)\8, (by-4+2+3)\8) 
  , check((bx-4+2)\8, (by-4+2+3)\8) 
 return a1 or a2 or a3 or a4
end

function hit_blockdisc()
	for p,hit in pairs(collision) do
 	if hit.sym == 4 then
			sound_ref = 48 + hit.col
  	if collisioncol[hit.col] then
				local mx2,my2 = hit.mx + hit.dx, hit.my + hit.dy    
    if not(mx2<0 or my2<0 or mx2>=15 or my2>=11) and
    	mget(mx2,my2+offsetfield) == 0 then
  			--next field is empty -> move  
     mset(hit.mx,hit.my+offsetfield,0)
     add(movingdisc, {char=hit.col+24, mx=mx2,my=my2,dx=hit.dx,dy=hit.dy,c=8, x=hit.mx*8+4, y=hit.my*8+4})
    end    
   end
  
  elseif hit.sym == 3 then -- blocks
  	if collisioncol[hit.col] then
   	mset(hit.mx,hit.my+offsetfield,0)
    create_splitter(hit.mx,hit.my,ballx+4,bally+4)
    
    blocks -= 1
    if bonuscol == hit.col then
    	bonuspoint += 0.1
    else
    	bonuscol = hit.col
    	bonuspoint = 1
    end 
    
    score += bonuspoint
    sound_splitter = 24 + hit.col
   else
   	sound_ref=48+hit.col
   end
   
  end
 end
 
 --check all corners
 
end

function gamelogic()

 if blocks>=0 and bonus > 0 then
 	bonus -= 0.4 
 end

	-- init collision
	collision = {}
	collisioncol = {[ballcol]=true}


	-- first move ball left/right
 if ball_col(ballx, bally, balldx, 0) then
 	balldx = -balldx
 end
 ballx += balldx
 -- stop on edges
 if (ballx+2) % 4 == 0 then
 	balldx = 0
 end
 -- move ball up/down
 if ball_col(ballx,bally, 0, balldy) then
 	balldy = -balldy
 end
 bally += balldy
 
 hit_blockdisc()
 
 
 	-- x-movement only all 2 pixels
 -- makes it easier to perform special things
 if bally%2 == 0 then
  if balldx == 0 and button then
  	if button == ⬅️ then
  		balldx = -1
  	elseif button == ➡️ then
  		balldx = 1
  	end
   if btn(🅾️) and (ballx-2+balldx*4)\8 != (ballx-2)\8 then
   	balldx = 0
   end
  end
  
  button = nil
 end
 
 if blocks <= 0 and waitwarp >0 then
	 	waitwarp-=1
 end
 
 
 for nb,disc in pairs(movingdisc) do
 	disc.x += disc.dx
  disc.y += disc.dy
  disc.c -= 1
  if disc.c <= 0 then 
  	mset(disc.mx, disc.my+offsetfield, disc.char)
  	del(movingdisc,disc)
  end

 end
 

end

__gfx__
0000000022776622666d666d00100100227766222277662200000000111111110000000000000000000000000000000000000000000000000000000000000000
0000000027166162d555d55500010000271666622716666200000000110000110000000000000000000000000000000000000000000000000000000000000000
00000000271761626d666d660100001027176162271766620000000010000001000cc00000088000000ee000000aa000000dd000000bb000000ff00000066000
000000002276662255d555d5000001002276662222766622000000001000000100cccd000088820000eee80000aaa90000ddd50000bbb30000fff40000666500
0000000022276222666d666d100100002227622222276222000000001000000100cccd000088820000eee80000aaa90000ddd50000bbb30000fff40000666500
0000000027222262d555d5550000000127222262272222620000000010000001000dd00000022000000880000009900000055000000330000004400000055000
00000000227766226d666d6601001000227766222277662200000000110000110000000000000000000000000000000000000000000000000000000000000000
000000002722226255d555d500000001272222622722226200000000111111110000000000000000000000000000000000000000000000000000000000000000
7777777c777777787777777e7777777a7777777d7777777b7777777f777777760077770000777700007777000077770000777700007777000077770000777700
7ccccccd788888827eeeeee87aaaaaa97dddddd57bbbbbb37ffffff47666666507cccc700788887007eeee7007aaaa7007dddd7007bbbb7007ffff7007666670
7ccccccd788888827eeeeee87aaaaaa97dddddd57bbbbbb37ffffff4766666657ccddccd788228827ee88ee87aa99aa97dd55dd57bb33bb37ff44ff476655665
7ccccccd788888827eeeeee87aaaaaa97dddddd57bbbbbb37ffffff4766666657cd007cd782007827e8007e87a9007a97d5007d57b3007b37f4007f476500765
7ccccccd788888827eeeeee87aaaaaa97dddddd57bbbbbb37ffffff4766666657cd007cd782007827e8007e87a9007a97d5007d57b3007b37f4007f476500765
7ccccccd788888827eeeeee87aaaaaa97dddddd57bbbbbb37ffffff4766666657cc77ccd788778827ee77ee87aa77aa97dd77dd57bb77bb37ff77ff476677665
7ccccccd788888827eeeeee87aaaaaa97dddddd57bbbbbb37ffffff4766666650dccccd00288882008eeee8009aaaa9005dddd5003bbbb3004ffff4005666650
cddddddd82222222e8888888a9999999d5555555b3333333f44444446555555500dddd0000222200008888000099990000555500003333000044440000555500
9999999499999994999999949999999499999994999999949999999499999994666d666d666d666d666d00000010666d666d666d00100100666d00000010666d
9442244294422442944224429442244294422442944224429442244294422442d555d555d555d555d55500000001d555d555d55500010000d55500000001d555
942cc24294288242942ee242942aa242942dd242942bb242942ff242942662426d666d666d666d666d66000001006d666d666d66010000106d66000001006d66
92cccc929288889292eeee9292aaaa9292dddd9292bbbb9292ffff929266669255d555d555d555d555d50000000055d555d555d50000010055d50000000055d5
92cccc929288889292eeee9292aaaa9292dddd9292bbbb9292ffff9292666692666d00000000666d666d666d666d666d00000000666d666d666d00001001666d
949cc94294988942949ee942949aa942949dd942949bb942949ff94294966942d55500000000d555d555d555d555d55500000000d555d555d55500000000d555
94499442944994429449944294499442944994429449944294499442944994426d66000000006d666d666d666d666d66000000006d666d666d66000001006d66
422222224222222242222222422222224222222242222222422222224222222255d50000000055d555d555d555d555d50000000055d555d555d50000000055d5
00050000005d000005d60000005775000000000000060000006000500550005577777777700d7777777776577117771777710d77777d000000000000777d5577
055000000dd50000566d0000006776000006600000656650066506655550005567777777755777765677711771166500776007777777d0010000000077777777
050000005d500000d665000000777700006766000665555065500065550000001677777775776000057776077100000077506577d1111d7765000000d7777777
50000000dd5000006660000000777700067776600660066505000050000000000055d5d77d7710000177760675000000660d767751d677777610000006777776
50000000dd50000066600000007777000667766006500655000000000000000000000017667600000067d005d000000000017777777777776100000000d66d50
050000005d500000d66500000077770006666600056656500665006500000000000000065d610000000100000000000000005777777776d10000000000000000
055000000dd50000566d000000677600006600000055555006550065055000550000000000000000000000000000000000000055d55100000000000000000000
00050000005d000005d6000000577500000000000000000000500050055000550000000000000000000000000000000000000000000000000000000000000000
00000000000001aaaaaaaaaa655000000000005ed451000010000000000000000001000077610000000000033d33100000000510000000000000000000000000
0000000000005aaaaaaaaaaaaaaad100000014eeeeee4014810000000000000000df500017775000000001bbbbbbb5000005ddd1000000000000000000000000
000000000000daaaaaaaaaaaaaaaaad500004eeeee10008882000000000000000dff60000677710000000bbbbbb2000001ddddd5000000000000000000000000
000000000000aaaaaaaaaaaaaaaaaaaad000deeeed00028882000000000000001fff600000677710000003bbbb5000001dddddd000000000000000005ccd5000
0000000000115aaaaaaaaaaaaaaaaaaaad001eee500004888100000000000000dfff5000000d7750000005bbb5000001ddddd5000000000005ccc505ccccccc0
00000000d66655dd5aaaa555daaaaaaaaa000101000028884000000000000000ffff00000000d6d0000000100000001dddd555dddd100001ccccccc1ccccccc1
00000056666650000daaa0000001aaaaaa100000e50028881000000000000005fff5000000000000000000001b5000dddd5dddddddd5001cccccccc55cccccc5
00000d66666650000daaa1051001aaaaad00005eee1088840000000000000006fff100000000000000000005bbb005ddd51ddddddddd00cccc50dccc1ccccccc
00016666665000000daaa1dad000faaad1deeeeeee128882000000000000000fff60000000000000001dbbbbbbb10dddd000100ddddd15ccc5000cccd3cccccc
001666661000000005aaa5aaa100aaa51eeeeeeeee058882000000000000001fff4000000000000001bbbbbbbb305ddd5000001ddddd5cccc00005cccccccccc
016666d0000000000daaa1aaaa0015000eeeeeeeee128880000000000000005fff5000000000000000bbbbbbbbb15ddd1000005ddddddccc500001cccccccccc
06666d00000000000daaa1daaa5000001eeeeeeeee448880001222222000005fff100155d455100001bbbbbbbbb5ddddd10005dddddd5ccc300001cccccccccc
56666000000000000daaa01aaaa600000eeeeeeeeed48885288888888810005fff5dfffffffffd0001bbbbbbbbb5ddddddd5dddddddd1ccc500000cccccccccd
66666666666d500005aaa00daaaaa0000eeeeeeee1088888888888888884205fffffffffffffff6401bbbbbbb350ddddddddddddddd51ccc100000dcccccccc1
66666666666660000daaa000aaaaad000eeeeeee5002888888888888888882dfffffffffffffffffd1bbbbbbb5005dddddddddddddd01ccc1000003cccccccc0
666666666666610005aaa0001aaaaa600deeeeee00048888888888888884845fffffffffffffff6ff5bbbbbbb0001ddddddddddddd000ccc5000001ccccccc10
d6666666666661000150000005aaaaad0eeeeeed00028888888884221000111ffffffffffd51000010bbbbbb500005dddddddddd500001510000000cccccc500
166666666666500000000000001aaaaa1deeeee100018888884210000000000fffffffd50000000000dbbbbb1000005dddddddd50000000000000005cccc5000
00d6666666500000000000000001aaaa14eeeee0000012884100000000000000dff650000000000000bbbbb30000000015d55500000000000000000015310000
00005151000000000000000000001daa65eeee400000000000000000000000000000000000000000003bbbb30000000000000000000000000000000000000000
0000000000000000000000000000005110eee5100000000000000000000000000000000000000000001bbb500000000000000000000000000000000000000000
0000000000000000000000000000000000de50000000000000000000000000000000000000000000000db1000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000077501777777d00016777760000001771
0000001d100000000000000000000000000000000000000000000dd000010000000000000000000000667777766100007600057777d0000d7777776001001771
0000d6777000000005760000010000000000000011100000000177750057610000000155001110000577777777777d00710000677d00005d67611115676d1770
00167777d00000dd677d0000d7750001510001677777d00000577750017776000000d77dd67777610d77777777777770000000777d0001777761567777775110
057776100000005777d000067777506777d057777777760005776d7765777710000d77d67777777710ddd77d5d67777d000000d7771000677777777777750000
16761d7d5000016777d0001771d7667777717777611577500676d76777d7776000d77dd7777511776000177110057775000000016650001677777776d5000000
6776777760000677777ddd5770067776777d5dd77000d71057700107775677750d77605d57750017d000177d7d0577d0000000000000000015dd550100000000
777777776000677d677777d7700677d777750067600001006760001777d0677657771000577100001000177d7711d10000000000000000000000000000000000
82c2c2c2c2c2c2c2c2c2c2c2c2c2c292e23030303030303030303030303030f2e23030303030303030303030303030f2e23030303030303030303030303030f2
e23030303030303030303030303030f2e23030303030303030303030303030f2e23030303030303030303030303030f2e23030303030303030303030303030f2
e23030303030303030303030303030f2e23030303030303030303030303030f2e23030303030303030303030303030f2a2d2d2d2d2d2d2d2d2d2d2d2d2d2d2b2
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04142434445464748400a4b4c4d4e4f405152535455565758595a5b5c5d5e5f506162636465666768696a6b6c6d6e6f600000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000071727374757000067778797a7b700008393a3b3c3d3e300f3c7d7e7f7940000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d60cff368f18d68fdad3877751f5e5c7bf0fee1cf6c63cf0c0fff8800e70c12067d9df304fb48ff0b90815b7ff00df21effc9a1bf7084192252190ffffbc02bc
2bc2bc2b068168168168368168168360068160060c03003003c08168108168103c00c00c03060068160068368168168368168168160c03c03c03c0cb89b436f8
bc81bfc5296cc5e76cc56c8dbe2d8d6e296cc5e36cc5a13796cc5a1b3d5a13796c63796cc5a13797813796cc5a13794a13796ce0796c61796cc56c8dc5a1b9b4
36e296cc52d89bc7c8dc5a1b9b4363796ce179136e296cc5a1379791379c0d8d3e236ce2980e120100bd0f807d667108348ce1e176b9428e7cf79d3c63c63c63
068168160760b70c0bd0bd0ec66f081081681c91ce103003c6383b9d3cf7d8e68160e88168168180288168168183268168160280268168160e88168168180288
168168183268168160280268168160e8816816818028816816818326816cb9815cd3c21cb341940fe0bc18f68121428f6812f0e91684284287685e1420068128
c7006852142842872f3e0421e82e37733683ca2c82e177336834f00077b1e01401089137783401400c8d6834014006ee6a4c2202800813776c07a00c63f6be07
abbd00b687dd91b9b5b6b1e4776cca9741fff0c0fc00c0fd0b16b168760900c0fd070ff30ff528028028020401401401408758558358d58158f58b504ed46d4e
c46f46c4ef4ee240ecc0200200200a35814014014014080280280280014014014010280280280204014014014080280280280014014014010280280280204014
014014c1400400400881b7f86896f87b74284b7c9d7036f9bbb40de2f77913833f7791bf0ece3d74d913a1fa17b0fb17a1bb190f3021e7042cf082426c0fc081
ed163cb3c03060060068b68da8168163c00c00c03c0810810e0d8168103003003c03063060c68168b60c07c081081eb10b10b83a06ce3ce2ce7c68d18d18d18d
f70cdef704ff10b80080080082080280280246410b8008008080028028028018008008008a6ca0280280280207c17c17c1128028028028040140140148028028
0280201401401401280280280280401401401480280280280207c17c17c112802802802827a9ff1c13c03c0fffffffff7cefb03ce4ce0ce4c0bff2cff8f61aff
081bcef16f66706f763ce9ce4cefd28d79d58d69dd0df70abee9ead51f01fe5583eb0090ee2e64084e8708c16c3642740f811c134c8fc8c1f409326cf74ee0c6
421409bdac76401c17309b383e1b16b19bd8f250200c820100100e410400fb00cb2e1bb8bcd2eb0ea000df21e03883c62e078080084004200290a30a302973d6
2f7ad4ee4b9cb9839f3172772e4ede09fb34eee094c1ff5421029028408f00428420c30c3042e021709021428028020021c30c3040902040f0080290eb0298ff
136dd5dee1d3c2b96bc6bcea86746740780ffffae3c92b630c0a07aca914002c121470909401e61e8963d7bd23d62ba6ceac61b39d5cf08753aaf58ff5f678d3
f6f10893468cc500cbdf3cffcef309bc16e2f68eefd0ff572acff0efff7d10040807800100102c130600681e910300b1ea103003c0f815060060c07ce0c03068
1efbc71aff9e5ed633aedef3c8a7bf764db915f6a30ff3bfc8a733aed4426f915f664db90081dbcb915f664db9001064dbd164db915f628a0815f67815f6b90a
2064dbd164dbd62005450cb9cf2027608079ce1020060100578b4d760582cd1001001e210020020391494e252152150040040048b46c001001001478b4973d1e
453c400c7200b900aec0200e516772366fc8aacc9a7b30b7400c82e67600cda7b30b74004f04710036f06f80ff12cf780ff12d48f5ec63cfa179f5bd00cfabff
281b108d0300ee66c07c00c008bb913c681081607733607a381b10dd6ee66c07c030038bb1c8d00c07c0eeef71feeff3fe6342848b3b9331e7363cf0cc9a131e
fd42cd9d4f00304fc0f303cfffdec621e396bcff4400ff5ec63813c0ec638130c916036b1c9160360833c06c03833c07c63813c0ec63c0ffffb2a82a8409223a
ec040140108137ab1e7363c1e014017daa0ffbbf07a7bb28f18853c9b7cb953c9ede9a53cf0873b6837f4283dbd56d0fffff1223cffa5bb283dbd31b68f10f66
d07ee9c07a7bb28376d0f30edcad35c91f6f853cffff707d0fff6d23cf0f6b0e7066d0f30ed28f18953cf087b0e7066d0f30edca2effffbeb0140140140140e2
7c11407c11cd3026f07cd1c277078fffbd8df717707cd1c17f088d3407c11407c1114014414014440a90bf78168773c03ccba1b70b1681e0f60813c681683cb9
13c0b168d6dd68163c0fe0b16f36a1e704adfb5e052152152239e2181d50e516510407400401001c1100140040740040100ec0781300ed06d00833c16c608738
5300183b1c8100f60b60020833400401001068008020020c0100140046b126c68026d6b0a9b5b6f000f6f81585b30f87b300b6b1e3f6b106d687dbd00b687287
cb1eb428fc81e90e177081b1e57730c8d68fcdd6081b30f8bb30e5d8d300cdd365f0b00cadd8ff9103cf7ce6c3d1e9103c13c53c738b4853068f60068b70068b
7306876002b73392fa3c56c6300bd00c6300bd07def108df300e63d63d63d200df2c1ed6300bd00c6300bd00c08dfb10bf73815fbd6ad6ad4b0cc006c68f63c1
b50f463c19d2002b517468509165c1910bc08517460060065c191eb517468d60065c19120418517468005065c1912b10edc851e57318c18c1095bd0fb6c1e79b
bd0fb46e4647d10857593bd4f047100ba6c8428f80087536706f8008b5cded0089536706f8cd17e4d81940f19bbdc310ef428bf732733b60fcd8c117c07074e8
0394a143942c0e8c117893c36c8c11cf0c1932e81e0e8cdc1eb6c64eefd80ef42eaa1fa8d60bab16b52ed03c00b60c0b4cb16b106d08d690e7021cf0426473c0
816b129108d03c0852b103c6810b460060c03069c63c0816b12ff5168cffcef70bf73068db8103c0b703c0ff73c0b703c0816f260cefd0bff9cff4892ff3bf0b
f7300bb13003ce2c03003c0b1ef763c03003c0bb03003ce600bf73cebcff0e4dbd68106c0f973003c08103cc9d68168168d03c0bd0bd030ca160068108106e63
003063c0fffffffff0fa663f83dc365d8681cda1389336fb4037eee7006ec8df00cc5e700336f3ef37f3e05e6c123ba71780200200281504004004002769d681
6816b523003c03c08463068168d09c00c03c0302910810306b526476da306b91b129106dc8d06d030c852b1ca913ccad6081b460060c03069c63c0816b12ff51
50c2bc2bc2bc08168168168103c03c03c03028168168120c01c03c01c08168068068103403c03403028168168120c03c03c03c08168168168103c03c03c03062
09b4f109b6f8404ead3200ad1a86b940867409d1204b341de010adf204b70b74086f06f800de1ce110af520e500094c0421f010014004004020018004018d600
6b10422b30b32021bf1420b71028046f400200209d61088780c63088f804002e8b02c9e603a0c0657b100760813060b68bc120607b1c2e0f8330c8103853c510
208134cad68ff27bbd066181cbe608b3c16e681cb1038bc100398d0e110ccd1e0370c0ed0812ee6340037887b100034d4690e94694685062144cd169c0b00621
88b3c29160894010778523c28723c29161c39169c0bc73c2916f269c0ff29cefcff5562ff38ff1383e83e83e83e83e83e83e83e83e83e83e83e83e83e83e0fff
fffffd962d4a94396a678ff9569d69d69568ff9d19d6956b50ff3b56f663cffc2bd2bc69d18ff9d2bd2b32b50ff3135b68ff88bcf94cff303c9bb0b70ff9bd0b
70bd0fc0ffd3c11ef42ca2ef36ba6dcd91376337eecb95377eccc933b66c0ff31cf0441c31c3194100150044f40194144f400441001941c31c3150f301cff4d9
a557b66dba15bae5dda15fae4dcabdf15ccdc8a73ba3fa6ec8ecda530cc1c81ca1cb1cc1cd1c9105b6d99576e5dc5db9157650cc1cb1c91cb160b60760ccba5b
ec9a9becba13baee0ff79f3104fb4004834834834834834834834834006e08f10b88df70eff6ff68cf70cc9b336edc9dca91377edcc95337ec0ffffff79753be
6daa353ae5d9a153b57be4da22ff18e8bb3cf041ff51401401401028028028020401401401406d0f305401401401408028028028001401401401cf7973cf0456
53c03c03c03c03c03003c03c03c03c03003cc8a53c03c03c03003c33c033afb533ada53003c00c03003c03c03c03003c03c03c03c03c03c03003c03003c03c67
18ff99553665d89553665d89553665d8955368ffffff7caa13ba6ccaa13ba6ccaa13ba6ccaa13ba8ffffff7c89553665d89553665d89553665d8955368ff1334
efb6ff69c0ff2916f269c03c73c29168f68523c0fd0b468db8523cfb46f068d39ffa210ee1effffffdc1ccd00280e7401cb9309b1fffffff8d5513a65dbab57a
e5daa15fae4dd64a0ef841cf19283290e884900970844a408c3042252102900944a42002002984930f4e09270e9c125e0366dcb93377934138cffcef30ff7cff
1cff9e5c52802002c52002802c92802807902002c928028020074b408c1840846b46746b46ff78fffb9ff38ffffffffecff480cb2e70a8fffbd81e7063cf0c68
__label__
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
67677677767777777777777777777777677777777777777777777777777777777777777777777777777777777776777777777677777777777777777777777677
61101110111010101101111111011011111111111111151511511111011111111111100151515110551551511105101101101101011111101010101010101016
61d000065ddd5ddddd5d55d5ddddd50150577777777777776d10d510dddd5ddd5ddddd1077777771d77777777760ddddd5ddd5d5dd5dd5ddd5d5d5d55d5d5d56
7115610055dddddd5d5d5d5dddd551d15d67777777776766105d015dd5d55dddddd657d077677777057777777771dd55ddd5ddddd5d5dd5d5dd5dd5d5d55dd56
7056776005ddd5dddd5d5dd556555501166677777776d5d05d01dd5d5d5d5dd5655dd5d5167777776057767777760dddd5dd5d55d5d5dd55d5d5555d555d5ddd
71d76666005dddd55d55d55dd5150050606777777765d105101ddd5d5dd5011ddd6dd6dd05777777651d77767676055d5dd5d5d5d55d5dd5d55dd55555d5d556
617677776d00d565d55dd5dd515050656777776761d10d105ddd565d510076d1155d55dd5057777777d067777777605d5d5d5d5d5d5555555d555d55d555dd5d
60d6666777610d5d55d5d5d55505160d6577767615105015d5dd55d50157777700555dd5d10d7777767157777677701d55d5d5d5d55510155d5d55d5555d5556
715166767761055d5d555d510150606616776761d0551555dd5dd510567776767101d5dd651077767777066767767605d55d55d55d5501505555d5555d555d5d
61560166760005d5d5d5d5151116166d667765560510d5dd5dd55005677767671700dddd5d50677777771177777676101101155555d16001011555d55555d55d
615676d101660dd55d55d50516d1761d776656505055d5d55d5016777777761077005d56ddd506777777d6dd66666760667776655d50676d01055555d555d55d
7150667606d05ddd5ddd51516616615776716dd50d5d5ddd510076777777d05777015dddddd50567776716510010100056777765d5d11d655005d5d555555d1d
605001660d016d5ddddd151d6176557676165d105d55d55d00567777777516677700dd555ddd106777765776777766d015d67765dd5d50100055d55dd5d55d5d
717d5500005d6dd65d5511d7177616776165d11d55dd5dd51dd77777761166777701d5dddddd501776716666666777106d516675dd55d510155d5d5d5555d51d
615717601d6666d5011006657661777d6615155dd55d5d5d0650166711d777777701d5d56d6dd10d775167666677710001607761115ddd5d55555d5555d5dd56
70561760d6d6d650661d6656761676d560d15dd55dd5dddd0d7710565677677777055dddddddd101661d76676767d10000607610110115dddddd55dd55d5d51d
61d71760d66661017151657761666dd715155d5dddd5d5dd05677d577777777777055dd5ddd65110776666666dd1105001606101666511155d55d555d5d5d55d
70d61760666d1057d057577755656575515d5dd55d5dd5dd01777776677677776611d5d6dd5dd0d1d676511001055d67766010507d676d11155d5d55d5dd5d16
61561760d6611676517d67766616d7006dd5d5ddd5dd5d5d10777771776776777605ddd5ddddd177501106166771157d511017607615d115d1015d5d5d5dd55d
601166d06d61177056657761616561d0d66d6dd5dd5dd5dd10777760776777677d0ddddddd56d0677776d50116766d616501676067d1d66616601d5d5d5d5556
616677d0666507d15657675d5656157066d6ddd55dddd6dd1077776176766776750d5d6dd65dd16677777616055d1d10100676016d76661d516015d555ddd51d
616776506666060576667657ddd656706d6666d6d5d5dddd1067777077677667750dd5ddddddd0677767771601dd500610d76100010676506060555d5d5d5d5d
6166771066d600dd66776565d5605661d66d6665dddddddd50d7776167666766750d5dddd6ddd167777777dd151601510d77016716d07676770055555001555d
61d776106666011717771656161d566166d66d666565d5d65057777066767667750dddd6dddd51667676776501111100166056760671000166005d510d505d5d
71667600666d0167677666d671d65660666d666d6dddddddd056777167767667650ddd5dddddd167677776716666d6606d10556066665555110155101750dddd
70d55105d66d516667756175d56616616d66666666d65dddd017777167766767750ddddd565d51d77767777651101010d016001160561667500551155050ddd6
61d666666660166677d55656556607706666666d6d6d6d6dd107777167776767100d5d56dddd5d55151100101000000015556600611000160055100005d5dd56
70666666665556577716757ddd7717616510166666d656ddd107777167776760005ddd5ddd5ddddddddd0060d16601d1000016017766660005551155555ddddd
61d6666d66166767765d6d711777067015d70d6d666d6dddd1077775677761005d55dd6556d55dd6dddd105001050ddddddd501000056000d5d5d55d5555d55d
716666666d116d7761761655d777167167761566d6d7d6d6d101767577670001d5d6d565dddd656ddd51000115601d65d5dd6d00155000155d5d5dd5d55dd5dd
705d666661d5767717d67d517767176177776066666666d65d61057d76101ddd5dd556500010055d10105066006505dd55551dd5dd5d555d55005d5d5d5555dd
716666661d565776d6757155767717716777706d66d6666d65d5101661005dd5dd5d5d001117710d0016d0d510750d5d15555dd555d055551000055d5d555d5d
71666666161667777665d11677771671677771566666d666d6ddd500001ddd5dd5d5d5006616d50505d051d051710d0dd155d551d505555505615100d55d55dd
7166666656567771671615577777166077767d066d6666d6dddd5dd51d5ddd5dd65dd1000d5550050076160515710d1d5000dd1555d5555d1000d65055555dd5
75616666d165776566d6517777771d117767770d6666d666d65dd5d5dddd5dd5d5d5d0001010650d00d61001166015d510760155555d5d55015650000600d5d5
7110d66d656d77d671751777776755057676771166666666ddd6dd5dddd5dd5ddd5d51001157650d1010567600005d5501156501515d511d510150010600ddd5
7156066665d67617656057777677500d766676d0666666d6d6dd5ddd5dd65dd5ddd550066706d11d5000d67707505d5d1d101500555d15d5d5500015110d5d5d
617610d65657765616d1777677661006667677706666d666d56ddd5d6d5dd56dd5dd510066d1155d5d5001561d00ddd506017601555dd5dd5ddd15dd5dd5dd55
71607d0516677166161166d50110d67676767771d66666666dddd5d5dddd5dd5ddddd5d50005dddddd5d510000115551500665055515555551555d555d5d5ddd
7110d650557771d7d5000011076166676677776166d6666d6dd6dddddd5dd51115555d5dddddddd6dddd55dd5dd5551151000015550010101150d555d55ddddd
70111161d567d556615666660d7d5766676766665666666666ddd5dd5dd5501100015dddddddd56ddd5dd15d155dd1d555d5555150066776d7d0d5d5d5d5565d
71567dd5657716d1611666661177167677651055d66666666ddddd6d65501d77610001156dd6ddddd5dd5d5d051d005515dddd5050115dd01d50d55d5d5ddddd
716d5d75666716711d56666660d77661101d77506666666d6d6d56ddd0d777777777d500015dddd5ddd5d51dd5dddd5d5d151555056670dd6701d55d5ddd55d5
61d5d675577755d6066666666017600566777d056666d6666dd75dd5d0156777777777760001dd6dd5655555555d5dd5d15515d5101d70650605d5d5dd5d565d
7167717d1777d5061666666665161566667d10056666666666dddddd60651d777776776776105d5d555d5d5ddddd5ddd5d5d55dd550070660d15d5d5d5d565dd
71d7616d57766d16566666666605066651005dd66d66d6666d6d65dd5067505776661111155d6676dddd555151555ddd56555515dd116d16750d5d5d5dd5dddd
71577151d765d71660001155665011005d66d6666666666666d6d6dd511111556dd555555155d777766d55511151557665d551055550750650155ddd5565ddd5
7506d5066771165700000000056005d666666666d666666666d55011566d551155d666dd51511111155d6d666666656767615d5d5dd0d0110055555d5dd5d5dd
7110006767611d650d676110006666666666666d666666d50155665511156667655015dd6666777777777777777677677650d56511501567055555d5d5d5dd5d
75506777677055d06d7667760166666d666d6666666510566d500556677d11115d6666777667777777777777777776757d655d5d5d6106d155d55d55dd5d5ddd
710567776761560dd07d016600666d666d666d505d6515d66677d51156676655111556666777777777777777777777717d55001015ddd555d55d5d5d5d5dd565
6567776767656610606766760166666666611d66115667765111566751115d677777767777777777677776777777777566d0115650556d155d5d5d5d5d5d5dd6
75677777665666001000616601666666105d611d7777101d7766111566766d677777777767776665511011115d777766771005056005d100005555d5d5dd6ddd
7567777667166d01d7116d10066665006751d7775105777610156765015d77777676776510115ddd6677766777777767600d7710610dd00105055d55ddd5dddd
7567767767566517d6060d1066107d117777105677610567d11567777777d510115677777777dd6d6dddd675667777676175000d501dd156500155d55d5ddd56
75677677d717660655566d10106d1676651177771056751177767765101d67777777766d5551d6d6dddd6551d7776766d1d76016005dd156610555dd5d5d5ddd
71101066d716776050116106751677d1567761117651d777676115d77777766d50111d767660ddddd6d65506667776711150005100ddd50000055d555dddd65d
755d6517171667600010106557761167665117650d767665156776666d511d667777177677d1d6d65ddd511d66777770d05d606105dd5ddddd5d55d5dd5d5dd6
71d577111657667777605167d1166650d7615677761166766d110155d0677777777716676760d61056d501615677776d70156d50dddddd5d5d5d55d55ddddddd
755d571056d66777776166d1676d1566116676611d76651115dddd6d506777777777066677d0651106d611d55777677761550005dddd6dd5ddd5d55ddd565ddd
75511501666dd7766516556761156d157666115666510d6666d6dd5d10677777776705676750dd16015d1d5d67777776d6060dddddd5ddddd500d5d55d5dddd6
757110057775d77717d16761167d5d76d5157655015666666d65dddd5067777777771d6677516651066506066776777616115dddd56d65550000d5d5d5d5dd56
71111d15777177771d7611665567d51d765110666666666666dd65dd10667777676706676610dddd111155d5777776771d60dddd6d100556710155d5d5ddd6d6
7166611577717765665166556651d765156750666666666d66ddddd6550567767777066677016d6ddd506061767767761160dd5d551576651010d5dd5dddd5dd
757777777776776751d755765566d115677750666666666666d65ddddd505677777706776705d6d66d1161717776767651dd5dd6510d100010d05d5d5d5dddd6
7577777777677761d76166dd6d55d1556677506666666666655d6dd656dd01d776771666770555dd65505d656777777761161dd5d10156675010d5dd565dd65d
755111010677766751777615d666650615001166666666510551dddd6dd6d50077670d77660d0515d515065667767766d51111d6d11776771005dd5dddddddd6
71116665077776616776d15551166d0066d50d6666661001607156d6d65dddd016761667761d1050d10d5716677767771611605dd5167777101dd5d5dddd6dd6
751001010677775d667715550106660110105666651001d75166156ddd6dd6dd00d70667650d11d15506d717677767665615551dd507dd51005d5ddddd6ddd56
751666010667777001770676561d66d51115666d00016777067711dd6ddd6d6dd10d0d5100161011511666577777767d65d10605dd1000115d5dd5d5dddddddd
61566d0111d7767657d616611751766666661000d777777d17777505dd65ddddddd00000dddd6ddd115175d66776776661616060ddddd5d5d5d5d5d6ddddd6d6
71100101675165166610011067d06666666100d777777770577776106501d6d6d6d60060ddddd6d61060756d677777177d5655155ddd5dd5d55d5dd5ddd65ddd
7056661077d010017d0777557660676666d06677777777d07777760000105d6555d170706d6dd6561061706d677777d6670606051ddd5d5d5dd5ddddd56d6d66
711677606650d10761177606761066666601777777776610777761056650051010517070ddd75d6551d57175677777750756156011dd65ddddd65d5d5dddddd6
7511005750017666000011d7d1066666601677777777710d7777601105d11056060d616111001dd51516717177776770566070661115d5dd565ddd56ddddd656
71d1667660066d50d76501770166666650d77777777760177777101d77716067600770001dd60dd1060775717777777d71757d070515dd5dddd5d5d5ddd65dd6
7155176100165056610d567d0666666601777777767710d67767106777755117d0176066661d01d116176561777676767076661dd111d555d5dd5d5dd5d5d6d6
705600001566057511107760d666666d0d7776777776107777770577776706005d0601000d6010d50d57757177677777d657176075115ddd5d5ddddd56ddd5d6
75d6666666660671567775056666666057776776777606777775167777770500000610777771015555666d716776776507176011d75505d5dd6d5d5d55ddddd6
71d66666666606776077d016666666507776767777650767677106777776501ddd105077777d011651676d7177761000076d7100067150dd5d5dd5d656d65d56
71d66666666615776167016666666d007776767677705777776000677677601dd655516776101616d16766657d100000167d77510167151ddddd5d5dd5d5d6d6
65d6666666661176705d0d6666666511776677777750777777501017776700dddd6dd11d0167765d71776671100055677777777751771d515d5dddd5dddddd56
75d666666676d056660076666666d01776676676760d77777601d50175015dddd656dd56dd1105557177761001677777777777777777d0011dd565d6d5d656d6
7566666666666d100001666666661057677676777117777775056d10001dddd65d656d6ddddd6555656760017777777776555677777777d015565dd5dd5dddd6
75d66667676667666dd66666666601776767677770d77777710ddd655ddd6ddd6dd6565d66d6d551657600567777777d1567751d7777777d105ddddd56dddd56
756666766676666666666666666d0d767676777676777777601d6dddd100dd656515556d6d6d65d1657101d77777777777777771677777776005dd5dddddddd6
71d66666766676dd101666666661177777677665767777770070d6d505111dd6000777d50155d5616500577777777777777777761677777777505dddd55d5656
7566766551116510dd0d666d66506777777651117d077777011d1d6161011d650616776776156561d00d6777777777650156777715777777777d15d56dddd557
71d510015561601065156d666600777767511677771d7766061515d005715dd5116777777601dd6510177777777775001101677751777777777710ddd5dddd57
716015677776006111016666650577675001777776707775176005d167d0dd60d167777766156d65017777767777110d776d1777d17777777777610d5dd65dd7
711007777677061076056666d117611016777777776567607d011d65005d6dd171777767751dd6600677776d777600000677056760777777776666015dd5dd57
70150677776710077116d666106d00057777777677761710011d6ddd1dd6d650157677777116d651577775016771d00000770177d177777751101100d5dddd57
711705776767d0d77016666601101d777677777677775600dddd6d6d6d6d5001105dd6dd510d6d1077776057177060010177007761777751156776505dd6dd57
6057107766777017d066666d0515777677677676767761001111151dd650156660011010105d650077771176077060050777106760776015777777611dddddd7
71666066767775015d66666606677767667767677765101515511001101677776d10ddd6d6ddd105777617771670776d777750d76161d7777777776015ddd657
61677157677677056666d66150777676777776766110105656777d0056777677770050056d665007777557771d7177777777d11776777777d10105510dd65dd7
71667d1677777700666666516067776767776765005dd106556d60557777777767d0010501d6501777717777d575677777776007777777d105d71156065dddd7
75677616777676d066d6d6077117676777676000dddd61015100006077777777677101016d100017777177776077177776776107777751006777d0770ddddd57
716677157776677066d6dd111001776776101d66d6d65d510155156d07777766777600d66515005777607777717761d7777d100177500000016751770ddddd57
756677d177667671d6d6d6057d0076760001015d6dddddd6d55106760d77776767670017760d1057776576767077765011000115100dd05100665d770dd65d57
71666761767677761d66dd1176105d101610d711d6dd5d65dd650777006776767676d0015016001777d5761575d7777601106d556661d000117606770dddd657
71667771676777770dd6dd5077110005050151715dd6ddd6d6d1d7771117677676767000515d00d777d5556776177761d7615765d77561000677177706565d57
71d6677d6776776705d5d6d11d511d6ddd0676000dd5d6d6dd517777700d767676676700d6dd10577765677777167770775d567d6777d776776067770ddddd57
71d677775777777701d6ddddd510dddd6550611616d6dd6d6d5577777d007767676676101ddd505777617777776177717776501567775776750177770dddd6d7
71d6777716d51110006dd66d6565dd656dd50061d552d6d6dd1d77777610667676767660056d5017777177777770777d7777777777771dd1005777711ddd6d57
7066777676dd6676015665dddddd6d56d6d101006011056d6117777777d057776766777105dd500777717777676677777777777777760010d77777615555dd57
71d77776577677700d6d10666111d6dd56611511067776015067777777710d7767676777006dd0067776677675d7177716777777777d5777777777605dd51157
7166776067767610dd6d056650615dd61000000010006d01057777777776117776767777105d610d7777577715777177716777777661677777777710ddd15157
7167761d776776006dd6500150761d6d116d7d0515751076167777777767006767777777d05dd51077771676d6777d57771d767666117777777776015dd55157
7166751777777100d6ddd0667d1705dd10d5560dd100d110d77777777777101777777777751d6d1077776567777777d177711d66510577767777750155555557
655111511115110111551551515151555155551111555115555555555555d555dd5d5ddd6dd6d650d77776577677766615777777777777667777d05677777767
777777777777777777677777777777767777767777777777767777777777777777777777777777750677775d777665d77d1d7777777666117777106777777777
777777777777777777777777777677777777777777777777777777777777777777777777777777771d77777566775677776501dddd5100577776057767777777
77777777777777777777777777700077700077700007770077777777777777777777777777777776106777771d67777776767d6d55d616777761167777777777
777777700000000077777777770000077000777000077000077777777777777777777777777777777106777777d5677775167776d15777777610777777777777
7777770000000000777777777770007770007770000777007777777777777777777777777777777776017777777711dd6d666555677777776d01777777777777
77777000007777777777777777777777700077700007777777777777777777777777777777777777776057777777776d555dd777777777775016777777777777
77770000777777777700077007700077700077700007700007777000000077777000770000777777776601677777777777777777777777760177777777777777
77770000777777777700000007700077700077700007700007770000700000777000000000077777777761016677777777777777777777106777777777777777
77770000777777777700007777700077700077700007700007700007777000777000077700007777777777d011567777777777777776100d7777777777777777
777700007777777777000077777000777000777000077000077000077770000770007777000077777777777700006d7676777676651005677777777777777777
77770000077777707700077777700077700077700007700007700007777000077000777700007777777777777651001055d65d11000567777777777777777777
7777700000000000770007777770007770007770000770000770000000000077700077770000777777777777777777d651115556677777777777777777777777
77777770000000007700077777700077700077700007700007777000000077777000777700007777777777777777777677777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
__gff__
0002040100000000000000000000000008080808080808081010101010101010202020202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004352494c4c494f4e
__map__
c7a5b7e031363cf1163cc68627de82c7d8f0c45bf0181b9e780b1e63f9bce59328fe67f8016781d5165e5b386d91c01dac61f086c019120441100441dc61b086c01b86c0591004411004718720b086c01b9c21411004411044ee245993e44d92332982222882a2cb6500960158a2650086670996e11980055806601980015886
650096015896015892015806608992011880259292e159a227198025fa9261899e90e67f80fd38360003b0e118f66138060cc080e118806d008663c0000c188e611f86630330001b8efd40f31f21b06a347f0258c4ffff3f8cfd8fb5ff31766037feffff9f5acd9ffc26ffef6ecb3f00cb3b3ccb393ccb3b00cb3f2c7f82fc07
f279756bd5a857a76e2dd6ab51a76e8d3ac5ffe4d66af0c72b823ff8dc5933862b00e6ce983b6feebc0148006beebc59f366cd9bb10109b059f3e6ce98376bde8004983b6bc6bccd9d31774002c09b3b6fee66cd1b80e072676cf8823f68f0c72d16f0bffbf0edc5b31fc02eecc22e00fbf1ecc5b70fef1e1cdb706cf91f0ee0
ff7f05421408112040800001020408102040801005421408102040800001020408102040811005420408102040800061c28409136696ffd9ffe0ffffff499004411224f8ffff7ff63ff91f008b011b806df8860118ce610086731880e1dc700cff0fb728102441903e088220088a02411024e983200880a0281024019018e870
2a4532abc3dde60cc327e119008b8049c0dde60cc225e8b2aae8812e401b0eb9c567f2002441c22b9c3c00e500206bc3a107804ea7e0ff7f64c912b7093e6738dce20d8ee27586c32ddee0285e6738dce20dd0e2ffff0b43f81fa7db8447eeb6ce6a2b3c6a6bce9d0e3c3acc01de9c9903043833e70d80396fee8c095e2177c6
bc3903e0cd983b40803177de003d78f4583d84473d8c6e131e99db8aff894cfe07c3300cc330fcffffffff3100033000a2244aa2240affffff0f0ef445ffe14cff01fd07f41fa87e09fa0f18d52f39d37f4cff614cff117d12c2ffffffffffffffff3f0880000802200992200822ee0eabee0e8beed6e12cff2363ff24e187e4
143f24e18724fc90841f92f0c3a8841f929cfd93f23f57c1ff240172e0ca881f03011e380910204e0204886b20c003d740fc2009e4c04512ffff85c099c15dfcc071e40e1ee33b1efb488ef7488ec7c81d24c763e4c8911c8f912347723c468edcc363e4788dc70e5e3b9cca14ffff1fd1157c42adbab50ae113e8cea23b089f
308bee2c42f804bab3e80ec227440a842fb882ffff81dbe0ffe10ed7f003c33f40c30fc8281cfe94f00312ccfe90f00b1800639b39639b2493728a1f708b0afcffffdf7b70cf696b0cf79ca6c670cf696b0cf7a60dffff3f4e2f00bd7096ff91b1cbd925093f24e14725fc90841f92f043127e1895f04392b3cbd825e57f2282
23098024f83f611bb00dd8062c039601cb806dc036601bfeff3f766007ae25c392e15a322c1990043bb00389200ee19c5b58adb343a20098834e6f46854307acc9db24dc9a84c72c1e8fd60e0190d74327fecfe967ee01903f30861fee8c7945ebc01f03387c230e821f8883201e823808822408e2200882208883204882200e
827808e220f88138387c2330f0c7489048f807013cc4c71d84cb201e73100ceaa02408105e4180000992201c02254a02845f84f04890284078244a902048aa5b9c321bbb010186010186011880011880614080614080014980010186010186011880011880614080614080014980014980010186010186011880011880617886
013903f2e330f75a1bfe573f5ee10724fc8070ea01e0ce2220099f3b5c56dde21a00f9a4bc1e4e0177b8cc460cffff5f59706759165c599665597038dd6d1440966559163ccbb22cb8b3e0ffff4bb1decc19c3efcc982440121eafe6bc3915f4e030aa034a221c66f1c8dd261cce001d00044882456790e00e12e0cd9c004838
24c89824088f5b41de24c12a4e9993042089dc4a32162b0ec4c16324080204018ed80892380840dff4e1da867f0fde6dd986770ffe6db8f44d1ffea7abf91f098ff0e870f6688f0e638ff6e8c02fc9297ea392f0eb70f6688f8e3ddaa3c3d8a33d52fe07c043f8ffffff7f40d3344db8f4e2d2344d13feffffff1ff010feffff
ff1f90334d9355e1d28b4b4e654dd384ffffffff073c8edf2050ed1600fdc27f1080760b807ee13f0840bb0540bff01f04a0dd02e071fc0601c8aab75700f40bff410032eaec1500fdc27f1080bc5a7b0540bff01f3e01c8a9b157007c2e458a1429929cfd8751fcffffffffffffffe3d4d87f489122458a248f7833e616fa9c
02f066cc1da0078f3763ee0048c2e5cd983b1c16f17933e60e87457c5e8db9c361119f3763ee7058c4e7cd983b1c16f17933e60e80245cde8cb903f4e0f166d41df45905f02167ff04ec9f00a3ba9ce9c1b1078f411cce1e3c0671e872aa035f3405bf26fcd084ffffaf18e03f75e3d14ee1d1e6ec3036e1d19cced89ccd98f0
68737618dbf068ce66acce664c78b4393b8c4d78947dc2a31bff17013cc1136080800002020c081020408000010204081020408000010204081020408000010204081020408000010204081020400001010404089ee0c947f05ffa0520b80320d0890008822b088020d081200082c0d816040110e8421000c11904806e14ff51
e069ee3618dbb00ddbe44e0f2441d236088255084e01b7c6400116053814e06e4621088220c0dd04411004019b200882206013044110046c82200882804d100441100e011000e190101e6f00867f1bfe2d1bfe6df88761f8e10eff86611b9efd78366038369cc30f7875575c18c5ffff70b6e131b6e17096e2319ae170b6e131
b6e17fad6d78bc6d38aca578bc6638ac6d78bc6df8ff1f1e700ba3000aa000dcc1200882200814ff451004411040f13f044110040114ff4310044110ff4b10044110a8531805500005e04c24f88fe0f1f6e0288ecd9c3773de062000b699f366cedb06b805e06d33e7cd9cb70d088099f3f698f3063805e0cd9cb7c79c372000
3673de3673de0658c5e16de6366f03103c7b7098c57f44866e85c79c3567ee8c41c165ce9a3377c6bce13467cd993b63de8c01a80073d69cb933e6cd983b0012cc5973e6ce983763ee9c4166015873e6ce983763ee9c59830e387367cc9b3177ceac9983bc5a15dc19f366cc9d336be6f019f366cc9d336be6707a33e6ce9935
73b89c0ac6dc39b3660e8fd252398dac466623a311feffff3ffd12b07f0274031e01551224411220087028c0a470087028c0a20097022441122441001ebd6dc99e64abb1ff71bbff70f61fb5ba257b926de6fea3f8ffffffffcb688b2ba85114455114659aa6699aa64d100441100408800008800001100001100e4110004138
044000844310004110800982200882304dd3344dd3a2288aa228cad113fc090e630fde0dc0866fc3b50dc0866fc3d1e107367cce86c7d87039ebf0181b800def1e5c09fe44e256f144c393601a9ca9b0a8c1993b381311b983331109227730a620720763de604c85570dc614c41ba2610aa261c11444c6e04dc18c211adc2988
8c21813b050e35b853316788066b22226788454cc13305188b8e7873e70d2ef10806a1033adc0130480857bc0182412278e20e906090708b23de004130480440dc0102048384807803044030480872070887609000bc013a00c1202177788d429257a8d05b600d8031b73287c01a00e1f086c39959604ee50e8f314003bc0170
061804600e1671c8ab31c01d9ce1b00693d61467b8dc41381c02b00677c2e10d8039970062d5198c217007c01c006b388d4180b7608039c0994700ee8c7ed02b106b2f10c0d90d1805dcdd40006337e016f076030172034e016f3710c0d80d5805dcdd40006b376016d80d78c8dc56777366cc99bb9913b0c3dd9c1973e66ee6
0418d5353d009c5d780c0270f6b8c56310803ea73af045ee14fc9af04313feffbf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
180200002f5772b577205771557700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
18020000315772d577225771757702000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000
18020000335772f577245771957704000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000
180200003557731577265771b57706000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000
180200003757733577285771d57708000080000800008000080000800008000080000800008000080000800008000080000800008000080000800008000080000800008000080000800008000080000800008000
1802000039577355772a5771f5770a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a000
180200003b577375772c577215770c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c000
180200003d577395772e577235770e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e000
94030000231711f1711a1711817113171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9403000025171211711c1711a17115171020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000
9403000027171231711e1711c17117171040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000
940300002917125171201711e17119171060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000
940300002b1712717122171201711b171080000800008000080000800008000080000800008000080000800008000080000800008000080000800008000080000800008000080000800008000080000800008000
940300002d1712917124171221711d1710a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a0000a000
940300002f1712b17126171241711f1710c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c0000c000
94030000311712d1712817126171211710e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e0000e000
30020000277712d771126020f6020c6020b6020a602096020960211602106020f6020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
30020000287712e771126020f6020c6020b6020a602096020960211602106020f6020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
300200002a7713077113602106020d6020c6020b6020a6020a6021260211602106020100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100001000
300200002c7713277115602126020f6020e6020d6020c6020c6021460213602126020300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000
300200002e77134771176021460211602106020f6020e6020e6021660215602146020500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000
300200003077136771196021660213602126021160210602106021860217602166020700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000
3002000032771387711b6021860215602146021360212602126021a60219602186020900009000090000900009000090000900009000090000900009000090000900009000090000900009000090000900009000
30020000347713a7711d6021a60217602166021560214602146021c6021b6021a6020b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b0000b000
d40000001a1701a170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d40000001b1701b170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d40000001d1701d170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d40000001e1701e170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d40000002017020170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d40000002217022170000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d40000002417224172000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d40000002517225172000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
300000000d4700e4700e470186601566013660106400f6500e6500c6400b6400a6400863007630066300563004630046200362001620016100161000610006000060000600076000760007600076000760008600
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
480200003f6703f6703a67036670346702c6701d670016700e6500e6500e6500e6400e6400e6300e6300e6300e6300e6300e6300e6300e6300d6300d6200d6200d6200c6200c6200c6200c6100d6100c6100d600
480200003f6703f6703a67036670346702c6701d670016700e6500e6500e6500e6400e6400e6300e6300e6300e6300e6300e6300e6300e6300d6300d6200d6200d6200c6200c6200c6200c6100d6100c6100d600
d40000001217112171000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
40060000206221b622126220f6220c6120b6120a612096120961211602106020f6020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d20200003f6713f6713f6713f6713f6713e6733c67339673376733467332673306732d6732b6732967327673256732467322673206731e6731d6731b673196631866316663156531365312643106330f6230d613
__music__
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 40404040
00 403b3c40
__meta:4f78820c-0dc1-11ed-861d-0242ac120002__
@5f56
10
@5f57
10
@5600
0405070000010000000000000060770067200061770006060000000000667707010000006007270000000020007070000000011060002011100010210000067133331311133312133313333311313333520071750717377777667650661712737707770177776677017707770100700077077701777766770000007001007070
0007070707070000000007070700000000000705070000000000050205000000000005000500000000000505050000000004060706040000000103070301000000070101010000000000040404070000000507020702000000000001000000000000000001020000000000000303000000050500000000000002050200000000
000000000000000000010101000100000005050000000000000a1f0a1f0a0000000207030607020000050402010500000002050e050e0000000101000000000000020101010200000001020202010000000502070205000000000207020000000000000000010100000000070000000000000000000100000004040201010000
0002050505020000000203020207000000030402010700000003040204030000000505070404000000070103040300000006010305020000000704040202000000020502050200000002050604030000000001000100000000000001000101000000020102000000000003000300000000000102010000000003040200020000
0006090d0106000000000306050700000001030505030000000006010106000000040605050600000000020503060000000402070202000000000605060403000001010305050000000100010101000000020002020201000001050305050000000101010102000000000f151515000000000305050500000000020505020000
000003050503010000000605050604000000030501010000000006030603000000020702020600000000050505020000000005050503000000001111150a000000000502050500000000050505060300000007060307000000030101010300000001020202040000000302020203000000020500000000000000000000070000
0002040000000000000304070505000000030403050300000006010101060000000709090907000000070007010700000007010301010000000e010d090600000005050705050000000101010101000000040404040502000005050305050000000101010107000000111b151111000000090b0f0d0900000006090909060000
0003040301010000000609090d06080000030403050500000006010204030000000702020202000000090909090600000009090905030000001111151b1100000005050205050000000505020202000000070402010700000006020102060000000101000101000000030204020300000000000a050000000003030000000000
007f7f7f7f7f7f0000552a552a552a0000417f5d5d3e0000003e6363773e0000001144114411440000021e0e0f080000000e171f1f0e0000001b1f1f0e040000001c3677361c0000000e0e1f0e0a0000001c3e7f2a3a0000003e6763673e0000003f2d3f213f0000001c040407070000003e636b633e000000040e1f0e040000
0000005500000000003e7363733e000000081c7f3e220000001f0e040e1f0000003e7763633e000000000552200000000000112a44000000003e6b776b3e0000001f001f001f00000015151515150000040e1f00000000003255375433007f006215171463007f003255575433007f007215771473007f007215771413007f00
020505022818280000000100010101000000040e050e0400000c0207020f000000110e0a0e110000050502070200000000010100010100000006030506030000050000000000000006090d09060000000003060507000000000012091200000000000007040000003255575535007f0003050305000000000007000000000000
000205020000000000020702000700000302010300000000010302010000000000020100000000000000000505030100000f0b0b0a0a000000000001000000000000000000020300020302020000000002050200000000000000091209000000001109052a3920000011091d120918000021130a557240000000020002010600
0204030605070000020103060507000002050306050700000a050306050700000500030605070000020003060507000000000b160d1f00000000000e010e040002040205030600000201020503060000020502050306000005000205030600000102000002020000020100000101000002050000020200000500000002020000
000e1217120e00000a050007090900000102000205020000040200020502000002050002050200000a050006090600000500000205020000000005020500000000100e15120d0000020400090906000004020009090600000609000909060000090000090906000004020005050603000001050b0b0501000006090509050000
0204020507050000020102050705000002050205070500000a0506090f09000005000205070500000200020507050000001e050f051d0000000e0101010e040002040703010700000201070301070000020507030107000005000703010700000102000202020000020100010101000002050002020200000500000202020000
02050e09090600000a05090b0d0900000204060909060000040206090906000002050609090600000a050609090600000900060909060000000200070002000000160915120d00000204090909060000040209090906000002050809090600000900090909060000040205050202000000010709090701000500050502020000
__meta:1bdaec14-d23c-4c68-9cbb-45d80342eabf__
{
	["pico8"] = {
		["binaryOptions"] = "-i 1 -s 1 ",
	},
	["SFXname"] = {
		[0] = "",
	},
}
