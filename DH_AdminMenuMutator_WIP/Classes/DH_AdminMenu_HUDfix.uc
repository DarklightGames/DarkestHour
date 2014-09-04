class DH_AdminMenu_HUDfix extends DHHud;


simulated function ExtraLayoutMessage( out HudLocalizedMessage Message, out HudLocalizedMessageExtra MessageExtra, Canvas C)
{
	local array<string> lines;
	local float tempXL, tempYL, initialXL, XL, YL;
	local int i, initialNumLines, j;
	
	//log("Setting layout for string: " $ MEssage.StringMessage);

	// Hackish for ROCriticalMessages
	if (class'Object'.static.ClassIsChildOf(Message.Message, class'ROCriticalMessage'))
	{
		// Set a random background type
		MessageExtra.background_type = rand(4);

		// Figure what width to use to break the string at
		initialXL = Message.DX;
//		tempXL = min(initialXL, C.SizeX * class'ROCriticalMessage'.default.maxMessageWidth);
//		tempXL = min(initialXL, C.SizeX * message.Message.default.maxMessageWidth); // TEST replacing above - needs way of getting maxMessageWidth from our classes?
		tempXL = min(initialXL, C.SizeX * 0.6); // TEST - works with 0.6 literal
		
		log("ExtraLayoutMessage: Message.DX =" @ Message.DX @ " Message.DY =" @ Message.DY @ " C.SizeX =" @ C.SizeX @ " C.SizeY =" @ C.SizeY @ " Message.DY *8 =" @ Message.DY *8); // TEMP
		log("ExtraLayoutMessage: initialXL =" @ initialXL @ " maxMessageWidth =" @ class'ROCriticalMessage'.default.maxMessageWidth @
			" C.SizeX * maxMessageWidth =" @ C.SizeX * class'ROCriticalMessage'.default.maxMessageWidth @ " tempXL =" @ tempXL); // TEMP
		
		if (tempXL < Message.DY * 8) // only wrap if we have enough text
		{
			log("ExtraLayoutMessage: tempXL < Message.DY *8  SO NO WRAPPING"); // TEMP
			MessageExtra.lines.length = 1;
			MessageExtra.lines[0] = Message.StringMessage;
		}
		else
		{
			lines.Length = 0;
			C.WrapStringToArray(Message.StringMessage, lines, tempXL);
			initialNumLines = lines.length;
			Message.DX = tempXL; // TEST added to fix problem
			log("ExtraLayoutMessage: tempXL >= Message.DY *8  SO WRAPPING TEXT: lines.length =" @ lines.length @ " Message.DX =" @ Message.DX @ " Message.DY =" @ Message.DY); // TEMP

			for (i = 0; i < 20; i++)
			{
				tempXL *= 0.8;
				lines.Length = 0;
				C.WrapStringToArray(Message.StringMessage, lines, tempXL);
				log("Testing with width of " $ tempXL); // TEMP uncommented
				log("Number of resulting lines: " $ lines.Length); // TEMP uncommented
				if (lines.Length > initialNumLines)
				{
					// If we're getting more than initialNumLines lines, it means we
					// should use the previously calculated width
					lines.Length = 0;
					C.WrapStringToArray(Message.StringMessage, lines, Message.DX); // TEST - seems this is where it's going wrong, as Message.DX hasn't been set/saved on the 1st pass
//					C.WrapStringToArray(Message.StringMessage, lines, tempXL/0.8); // TEST - this is a literal fix, but have added cleaner alternative above (Message.DX = tempXL)
					log("Wrapping using previous width gives us: " $ lines.Length $ " lines."); // TEMP uncommented

					// Save strings to message array + calculate resulting XL/YL
					MessageExtra.lines.Length = lines.Length;
					C.Font = Message.StringFont;
					XL = 0;
					YL = 0;
					for (j = 0; j < lines.Length; j++)
					{
						log("Line #" $ j $ " = " $ lines[j]); // TEMP uncommented
						MessageExtra.lines[j] = lines[j];
						C.TextSize(lines[j], tempXL, tempYL);
						XL = max(tempXL, XL);
						YL += tempYL;
					}

					Message.DX = XL;
					Message.DY = YL;

					break;
				}
				Message.DX = tempXL; // store temporarily
				log("Temporarily storing tempXL as Message.DX: value =" @ Message.DX); // TEMP
			}
		}
	}
}

defaultproperties
{
}
