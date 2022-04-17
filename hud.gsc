StoreHuds()
{
	//HUD Elements
	self.AIO["background"] = createRectangle("LEFT", "CENTER", -380, 27, 0, 190, (0, 0, 0), "white", 1, 0);
	self.AIO["backgroundouter"] = createRectangle("LEFT", "CENTER", -384, 24, 0, 193, (0, 0, 0), "white", 1, 0);
	self.AIO["scrollbar"] = createRectangle("CENTER", "CENTER", -300, -50, 160, 0, (0, 0.45, 1), "white", 2, 0);
	self.AIO["bartop"] = createRectangle("CENTER", "CENTER", -300, .2, 160, 30, (0, 0.45, 1), "white", 3, 0);
	self.AIO["barbottom"] = createRectangle("CENTER", "CENTER", -300, .2, 160, 30, (0, 0.45, 1), "white", 3, 0);
	self.AIO["barclose"] = createRectangle("CENTER", "CENTER", -299, .2, 162, 32, (0, 0.45, 1), "white", 1, 0);
	
	//Text Elements
	self.AIO["title"] = drawText("", "objective", 1.7, "LEFT", "CENTER", -376, -80, (1,1,1), 0, 5);
	self.AIO["closeText"] = drawText("[{+speed_throw}]+[{+melee}] to Open Ragnarok", "objective", 1.3, "LEFT", "CENTER", -376, .2, (1,1,1), 0, 5);
	self.AIO["status"] = drawText("Status: " + verificationToColor(self.status), "objective", 1.7, "LEFT", "CENTER", -376, 128, (1,1,1), 0, 5);

 	//Makes the closed menu bar visible when it's first given
	self.AIO["barclose"] affectElement("alpha", .2, .9);
    self.AIO["bartop"] affectElement("alpha", .2, .9);
    self.AIO["barbottom"] affectElement("alpha", .2, .9);
    self.AIO["closeText"] affectElement("alpha", .2, 1);
}

StoreText(menu, title)
{
	self.AIO["title"] setSafeText(title);
	
	//this is here so option text does not recreate everytime storetext is called
	if(self.recreateOptions)
	for (i = 0; i < 7; i++)
	{
        self.AIO["options"][i] = drawText("", "objective", 1.3, "LEFT", "CENTER", -376, -50 + (i * 25), (1, 1, 1), 0, 7);
		self.AIO["options"][i].archived = false;
	}
	else
	{
		for(i = 0; i < 7; i++)
			self.AIO["options"][i] setSafeText(self.menu.menuopt[menu][i]);
	}
}

showHud()//opening menu effects
{
	self endon("destroyMenu");

	self.AIO["closeText"] affectElement("alpha", .1, 0);
	self.AIO["closeText"].archived = false;
	
    self.AIO["barclose"] affectElement("alpha", 0, 0);
    self.AIO["barclose"].archived = false;
    
    self.AIO["bartop"] affectElement("y", .5, -80);
    self.AIO["bartop"].archived = false;
    
    self.AIO["barbottom"] affectElement("y", .5, 128);
    self.AIO["barbottom"].archived = false;
    
  //  self.AIO["info1"] affectElement("alpha", .2, .5);
  //  self.AIO["info1"].archived = false;
    
    wait .5;
    
    self.AIO["background"] affectElement("alpha", .2, .5);
    self.AIO["background"].archived = false;
    
    self.AIO["backgroundouter"] affectElement("alpha", .2, .5);
    self.AIO["backgroundouter"].archived = false;
    
    self.AIO["background"] scaleOverTime(.5, 160, 230);
    self.AIO["background"].archived = false;
    
    self.AIO["backgroundouter"] scaleOverTime(.3, 168, 244);
    self.AIO["backgroundouter"].archived = false;
    
 //   self.AIO["info2"] affectElement("alpha", .2, .5);
 //   self.AIO["info2"].archived = false;
    
    wait .5;
    
    self.AIO["scrollbar"] affectElement("alpha", .2, .9);
    self.AIO["scrollbar"] scaleOverTime(.5, 160, 25);
    self.AIO["scrollbar"].archived = false;
    
//    self.AIO["scrollbar1"] affectElement(20, .2, .9);
//    self.AIO["scrollbar1"] scaleOverTime(.5, 2, 25);

    self.AIO["title"] affectElement("alpha", .2, 1);
    self.AIO["title"].archived = false;
    
    self.AIO["status"] affectElement("alpha", .2, 1);
    self.AIO["status"].archived = false;
    
    //self.AIO["info"] affectElement("alpha", .2, .5);
   // self.AIO["info"].archived = false;
}

hideHud()//closing menu effects
{
	self endon("destroyMenu");
	
	self.AIO["title"] affectElement("alpha", .2, 0);
	self.AIO["status"] affectElement("alpha", .2, 0);
	
	if(isDefined(self.AIO["options"]))//do not remove this
	{
		for(a = 0; a < self.AIO["options"].size; a++)
		{
			self.AIO["options"][a] affectElement("alpha", .2, 0);
			wait 0.05;
		}
		
		for(i = 0; i < self.AIO["options"].size; i++)
			self.AIO["options"][i] destroy();
	}
	
	self.AIO["scrollbar"] scaleOverTime(.5, 2, 0);
	self.AIO["scrollbar"] affectElement("alpha", .2, 0);
	self.AIO["scrollbar1"] scaleOverTime(.5, 2, 0);
	self.AIO["scrollbar1"] affectElement("alpha", .2, 0);
//   	self.AIO["info1"] affectElement("alpha", .2, 0);
	wait .4;
	self.AIO["backgroundouter"] scaleOverTime(.5, 1, 193);
	self.AIO["background"] scaleOverTime(.3, 1, 190);
	wait .4;
	self.AIO["backgroundouter"] affectElement("alpha", .2, 0);
	self.AIO["background"] affectElement("alpha", .2, 0);
	wait .2;
	self.AIO["barbottom"] affectElement("y", .4, .2);
    self.AIO["bartop"] affectElement("y", .4, .2);
    wait .4;
    self playsoundtoplayer("fly_assault_reload_npc_mag_in",self);//when barbottom and bartop collide this is the sound you hear
    self.AIO["barclose"] affectElement("alpha", .1, .9);
    self.AIO["closeText"] affectElement("alpha", .1, 1);
   	//self.AIO["info"] affectElement("alpha", .2, 0);
}

updateScrollbar()//infinite scrolling
{
	if(self.menu.curs[self.CurMenu]<0)
		self.menu.curs[self.CurMenu] = self.menu.menuopt[self.CurMenu].size-1;
		
	if(self.menu.curs[self.CurMenu]>self.menu.menuopt[self.CurMenu].size-1)
		self.menu.curs[self.CurMenu] = 0;
		
	if(!isDefined(self.menu.menuopt[self.CurMenu][self.menu.curs[self.CurMenu]-3])||self.menu.menuopt[self.CurMenu].size<=7)
	{
		for(i = 0; i < 7; i++)
		{
			if(isDefined(self.menu.menuopt[self.CurMenu][i]))
				self.AIO["options"][i] setSafeText(self.menu.menuopt[self.CurMenu][i]);
			else
				self.AIO["options"][i] setSafeText("");
					
			if(self.menu.curs[self.CurMenu] == i)
         		self.AIO["options"][i] affectElement("alpha", .2, 1);//current menu option alpha is 1
         	else
          		self.AIO["options"][i] affectElement("alpha", .2, .3);//every other option besides the current option 
		}
		self.AIO["scrollbar"].y = -50 + (25*self.menu.curs[self.CurMenu]);//when the y value is being changed to move HUDs, make sure to change -50
		self.AIO["scrollbar1"].y = -50 + (25*self.menu.curs[self.CurMenu]);
	}
	else
	{
	    if(isDefined(self.menu.menuopt[self.CurMenu][self.menu.curs[self.CurMenu]+3]))
	    {
			xePixTvx = 0;
			for(i=self.menu.curs[self.CurMenu]-3;i<self.menu.curs[self.CurMenu]+4;i++)
			{
			    if(isDefined(self.menu.menuopt[self.CurMenu][i]))
					self.AIO["options"][xePixTvx] setSafeText(self.menu.menuopt[self.CurMenu][i]);
				else
					self.AIO["options"][xePixTvx] setSafeText("");
					
				if(self.menu.curs[self.CurMenu]==i)
					self.AIO["options"][xePixTvx] affectElement("alpha", .2, 1);//current menu option alpha is 1
         		else
          			self.AIO["options"][xePixTvx] affectElement("alpha", .2, .3);//every other option besides the current option 
               		
				xePixTvx ++;
			}           
			self.AIO["scrollbar"].y = -50 + (25*3);//when the y value is being changed to move HUDs, make sure to change -50
			self.AIO["scrollbar1"].y = -50 + (25*3);
		}
		else
		{
			for(i = 0; i < 7; i++)
			{
				self.AIO["options"][i] setSafeText(self.menu.menuopt[self.CurMenu][self.menu.menuopt[self.CurMenu].size+(i-7)]);
				
				if(self.menu.curs[self.CurMenu]==self.menu.menuopt[self.CurMenu].size+(i-7))
             		self.AIO["options"][i] affectElement("alpha", .2, 1);//current menu option alpha is 1
         		else
          			self.AIO["options"][i] affectElement("alpha", .2, .3);//every other option besides the current option 
			}
			self.AIO["scrollbar"].y = -50 + (25*((self.menu.curs[self.CurMenu]-self.menu.menuopt[self.CurMenu].size)+7));//when the y value is being changed to move HUDs, make sure to change -50
			self.AIO["scrollbar1"].y = -50 + (25*((self.menu.curs[self.CurMenu]-self.menu.menuopt[self.CurMenu].size)+7));
		}
	}
}
