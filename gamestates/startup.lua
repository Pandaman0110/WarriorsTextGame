local Quotes = {
	'"The only true borders lie between day and night, life and death." \n- Brambleberry',
	'"Strength doesnt have to be proved." \n- Firestar',
	'"Keep your eyes open, Fireheart. Keep your ears pricked. Keep looking behind you. Because one day I\'ll find you, and then you\'ll be crowfood." \n - Tigerstar',
	'"We cannot change our destiny. We just have to have the courage to know what it is, and accept it." \n - Cinderpelt', 
	'"I learned a lot. Friendship and kinship matter more than adventure. Boundaries only exist in our minds. A heart can travel to the horizon without moving a paw step. And I made the best friend any cat ever had." \n- Talltail', 
	'"There is always something that a cat can do, as long as he has courage and loyalty." \n- Firestar', 
	'"Kill me, kill me and live with the memory. Then tell the stars that you won." \n- Gray Wing', 
	'"You live like a rogue, you die like a rogue!" \n - Firestar', 
	'"I have traveled so far and loved so much, and yet I am still following the Sun Trail, heading for my new hunting grounds." \n- Gray Wing',
	'"Oh, and Mistyfoot? Never trust the shadows. My warriors wear the night like second pelts. If you wrong ShadowClan, you will never be safe in the dark."\n - Blackstar ',
	'"Fire alone can save our Clan."',
	'"Four will become two, Lion and Tiger will meet in battle, and blood will rule the forest."', 
	'"Before there is peace, blood will spill blood, and the lake will run red."' , 
	'"There will be three, kin of your kin, who hold the power of the stars in their paws."' , 
	'"The end of the stars draws near. Three must become four to battle the darkness that lasts forever."' , 
	'"Embrace what you find in the shadows, for only they can clear the sky."' , 
	'"This one will see into the shadows."' , 
	'"We are all born in blood. But it marks the beginning, not the end."' , 
	'"We came to tell you only one thing. Unite or die."', 
	'"Redtail was a brave warrior. His loyalty to ThunderClan could never be doubted. I always relied on his judgement, for it bore witness to the needs of the Clan, and was never swayed by self-interest or pride. He would have made a fine leader."\n - Bluestar',
	'"Thank you. You were right. I had to tell the Clan myself. You have a good spirit, young one. When it is time for you to receive your warrior name, tell Sunfall I would have named you Lionheart."\n - Pinestar'
}

startup = class("startup")

function startup:initialize()
	self.randQuotes = shuffle(Quotes)
	self.quote = next(self.randQuotes)
end


function startup:keypressed(key)
	if key == "space" then
		return gamestate.switch(mainmenu)
	end
	self:changeQuotes(key)
end

function startup:draw()
	self:drawQuotes()
end

----------------------------------------------------------------------------------------------

function startup:changeQuotes(key)
	if key == "left" then 
		if self.quote == 1 then self.quote = #self.randQuotes
		else self.quote = self.quote - 1 end
	end
	if key == "right" then 
		if self.quote == #self.randQuotes then self.quote = 1
		else self.quote = self.quote + 1 end
	end
end

function startup:drawQuotes()
	love.graphics.setFont(FONT_16)

	love.graphics.printf(self.randQuotes[self.quote], 16, 160, push:getWidth() - 32, "center", 0)

	love.graphics.printf("Press space to continue", 0 , 320, push:getWidth(), "center", 0)

	clearTextSettings()
end