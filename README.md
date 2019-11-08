DEVELOPER: Aldrin John Olaer Manalansan(AJOM)

~~~~~~~~~~~ABOUT~~~~~~~~~~~



AJOM's Dota 2 MOD Master is a "code analyzing tool" which targets present "ID" and copies its contents, thus replacing the other target "ID's" contents simultaneously. Since manual "copy/paste" method on items_game.txt(accourding to my experience) is hard enough,this tool is best and can sacrifice less effort on your time.

One of the best reasons why I(Aldrin John Olaer Manalansan) created this tool is that:
->Imagine every released "patch" of DOTA2, they add new codes inside "items_game.txt" so that they can register its "use". Also,you might not notice, they change some existed "ID's Contents" into something new, without you ever knowing.
->Generates a "Modified Clone" of "items_game.txt" from the "Library" Folder where all the desired code are injected.



~~~~~~~~~~~LIMITATIONS~~~~~~~~~~~



This Tool gives a bright help for MODDING DOTA2 and is very handy compared to manual MODDING, but there will always be Limitations that this Injector(Until now) Cannot Fix.Current Issues that exist(7.03 patch):

*This Tool needs to ReRun and ReInject all Item Sets every New Update/Patch with newly arrived items. It is because "items_game.txt" which is the script inside the MOD needs to be Reupdated/Repatched, the injector's work is to ReUpdate the Script to be compatible with the newly arrived items listed at the new "items_game.txt". IF THIS INSTRUCTION IS NOT FOLLOWED, YOU WILL ENCOUNTER WHEN LAUNCHING DOTA2 "ERROR PARSING SCRIPT" WHICH WILL IMMEDIATELY CRASH YOUR DOTA2 AND WILL REMAIN UNPLAYABLE UNTIL YOU EITHER "REMOVE THE MOD FROM YOUR DOTA2" OR "RELAUNCH THE TOOL AND REINJECT ALL ITEM SETS". Take Responsibility on the Risks!!!

*Bristleback's "Piston Impaler" item does not stack with "Mace of the Wrathrunner(morning-star like)" item. This is due to the unhandled process of bristleback's "piston impaler animation" vs bristleback's "morning-star animation".

*When playing "Online" Mode, some item skin parts for heroes do not show if "it has no default cosmetic item". In other words, this following posibilities will occur:
-Ancient Apparition's "Shattering Blast Crown" "Head" item does not show up because "there is no default head item attached to Ancient Apparition".
-Tinker's "Boots of Travel" "Misc" item does not show up because "there is no default misc item attached to Tinker".

This problem is common on "Modding by Scripting Method" but the MOD perfectly works on "offline/LAN mode".

*Cosmetic items that "the model's item animation was substituted into the default model animation" does not function properly as expected, Example:
-The animation of Legion Commander's "Blades of Voth Domosh" functions as single wield type animation (wields only one sword).
-Techies "Swine of the Sunken Gallery Set's" third member(which is Spoon) does not walk properly.
-Witch Doctor's "Bonkers the Mad's" Monkey was not moving properly but instead was touching witch doctor's Butt.



~~~~~~~~~~~CHANGELOG~~~~~~~~~~~
v2.5.1
*Fixed a bug where a Command Prompt(cmd) sometimes pops up.
*Recallibrated "Maximum Threads", last time it wait for all "n" number of threads to close, now it makes sure that only "n" number of threads run always

v2.5.0
*SPEEDY VERSION. Advisable to migrate on this version.
*Database Version 1.5 changed the previous v1 database version. This Database version is faster than the previous database version... But still Version 2(experimental) is still unbeatable when it comes to saving/preloading speed.
*Added "Maximum Threads" at "Advanced Section". This will limit how many simultaneous threads that can be used by DOTA2 MOD Master to extract model,particle effect files.
*Some bug fixes.

v2.4.0
*Integrated Decompiler Technology! This allows broad analization on model(vmdl_c) files, I am currently under reverse engineering how the decompiler interacts with the models.
*DOTA2 MOD Master can now detect Material files(.vmat_c). Say goodbye to "bad item coloring when playing online".
*Reworked the Resizing Logic... "Anchor" changed into "AutoXYWH".
*Some Bug fixes...
~~~~Author Comment: "Decompile > Modify parameters > Compile" Scheme for VMDL_C,VTEX_C,VANIM_C COMING SOON.... Long working progress....~~~~~

v2.3.3
*Added Rarity Color Coding.
*Added "Rescan Resources" Button at "Advanced" Section. This will rescan all resources avoiding inaccurate list of items at miscellaneous section.
*Fixed a Bug where "terrain" style cannot be changed.

v2.3.2
*Fixed a Bug where Folder names containing a comma(,) character to corrupt the settings, thus failing the program to launch.

v2.3.1
*DOTA2 MOD Master now supports Auto-Update Feature! You can disable this feature at "Advanced" Section.

v2.3.0 ALPHA
*Alpha Stage since no Bugs occured related to the subroutine-to-function migration of the application, but still analyzing for tweaks for future versions.
*Added "Radiant Towers" and "Dire Towers" Feature at Miscellaneous>"Multiple-Styles" Sub-Section.
*Added "Versus Screen" and "Emoticons" Feature at Miscellaneous>"SingleSource" Sub-Section.
*"Terrain" is now Moved at Miscellaneous>"Multi-Styles" Sub-Section.
*Recreated the "Single-Source" and "Multiple-Styles" Sub-Section of the "Miscellaneous" Section. Now, only one feature on this subsections can be selected at a time. I have been thinking that beginners who used this tools might get heache Seing so many controls.

v2.2.0 BETA
*Changed all Subroutines into Separate Functions inside this Application's Code. Still in BETA Stage because uncommon bugs are still not known and is still waiting to be tracked.
*Added Database VERSION 2. An experimental database that has no integrity verification, resulting blazing writing and reading speed on version 2 database files. 
-DISADVANTAGE: When the Database has will not inspect for corrupted item specification lines.
-Fix: "Verify Integrity Cache" Button is Added
*Added "Statistics" Sub-Section at "Handy-Injection" Section. This will report the number of item slots occupied by all heroes at the "Used Items Database" Sub-Section. The Statistics is helpful incase you missed applying a Modification on an item slot for a specific hero.
*You can now Open ".aldrin_dota2db" and ".aldrin_dota2hidb" directly using DOTA2 MOD Master. This will automatically Preload the opened Database file. To do this, simply Execute the ".aldrin_dota2db" or ".aldrin_dota2hidb" using DOTA2 MOD Master.exe .
*Added "Statistics" System Sub-Section at "Handy Injection" Section. This reports the number of unnocupied item slots every hero has for availability. This is helpful for those people who are trying to track down unoccupied item slots and occupy them with cosmetic items.
*Improved ERROR Logging
*Fixed some bugs

v2.1.0
*Added two new features at Multiple Styles Subsection of Miscellaneous Section:
~ Radiant Creeps - Scans all ID's with prefab = radiantcreeps .
-Dire Creeps - Scans all ID's with prefab = direcreeps .
*Fast Preloading Reference File now will be recreated every standard preload.
*Fixed Some Bugs

v2.0.0
*Added the External Files System. This feature can allow external files to be merged with the pak01_dir generated by this tool. This Feature is very helpful if you want to merge your custom model(.vmdl_c) and even particle(.vpfc_c) files to be merged with the operation. just include a folder where your custom files inside at "%A_ScriptDir%\External Files"
*Added "Fast Miscellaneous Preload" Feature at "Advanced" Section. This feature can lessen your waiting time preloading miscellaneous files, thanks to V for Vendetta's "VarWrite" and "VarRead" Function which made file writings and readings to perform blazingly fast. But this is just optional,since we always like to make sure that preloading miscellaneous should be accurate, it depends on you if you want to use this feature
*Integrated Alpha Bravo's "WM_MOUSEMOVE" Function which allows each controls to have tooltips. Now each questionable controls will have a tooltip present as guide. This will be helpful for new users of this tool. Incase you want to disable this feature, you can uncheck "Advanced > show tooltip guides"

v1.7.2
*Updated "Relic" into "Emblem".
*Integrated "Klark92's Draws" Function. This new Feature allowed buttons to have custom colors.
*Added "Patch gameinfo.gi" Button Option at "Advanced Section". Pressing this Button will Manually Patch gameinfo.gi Reactivating the MOD(pak01_dir.vpk) Found at "%dota2dir%\game\Aldrin_Mods\" Folder.

v1.7.1
*Improved "pak01_dir.vpk" detection
*Fixed a Bug where the default settings does not detect gameinfo.gi location leaving autoshutnik-method unchecked as default.

v1.7.0
*Added Voice-Actived Narrator Option at "Advanced" Section. When Enabled, a Narrator announces statistics about the Injector's Operations
*"HandyInjection","H.I. Used Items", and "Custom Heroes" now belongs on a SINGLE Section named "Handy Injection". Inside the "Handy Injection" Section there are three another Sections, the "Hero Items Selection"(the Old Name of this Section is HandyInjection), the "Used Items Database"(the Old Name of this Section is H.I. Used Items), and "Custom Heroes"
*Fixed a bug where adding check marks on specific items at "Hero Items Selection" fails to be updated at "Used Items Database"
*Fixed a bug where Heroes with "Multiple Alternate Models" are not extracted
*Fixed a bug where some extracted models and particles with the same name on a directory fails to extract, this was fixed by extracting and renaming them one at a time(which multiple CMD will not be applied on files with the same name)
*Changed the Name this tool from "items_game.txt injector" > MOD Master

v1.6.0
*Added two new SINGLE SOURCE features at "Miscellaneous" Section
-Multikill-Banner : When you continously kill enemy heroes within 10 seconds, A Glowing effect on the streak message will show up.
-emblem : A Person with the highest battlepass level will gain this emblem EFFECT, But playing OFFLINE will result the main user's hero to gain a emblem EFFECT.
*The Injector now Patches the "Portraits.txt" which change the orientation of the Hero on the HEROBAR.
*Cured the Bug where the HLLIB manipulation is wrongly approached resulting PARTICLE CORRUPTION among certain particle files, which some particles pops MULTIPLE RED CROSS(not yet 100`% fixed)
*The Progress-Bar now Flickers and has borders sketching the complete progress
*Added a New Feature on "Advanced" Section which is the "REPORT LOG". This feature reports what files are extracted and where can you find it. This can be helpful in some cases if you want to analyze all the Files which the injector had managed accourding to the amount of Data you wished to inject from your "Previous Operation".
-The Report Log is only Generated from "General" and "Handy Injection" Operation
-ModelRealName : The Name of the extracted File
-ModelLocationPath : The Location where the "ModelRealName" was extracted
-ModelDefaultName : "ModelRealName" was renamed into this name found at "ModelLocationPath"
-ParticleRealName : The Name of the extracted File
-ParticleLocationPath : The Location where the "ParticleRealName" was extracted
-ParticleDefaultName : "ParticleRealName" was renamed into this name found at "ParticleLocationPath"

v1.5.0
*The Injector now AUTOMATICALLY DETECTS New Heroes through "activelist.txt" feature. Unlike the last version has its defined hero list, but now using "activelist.txt" the injector now will scan all characters defined by DOTA2.
*Reworked "Migration" Method Section, which becomes more accurate on migrating items_game.txt.
*Improved LEAK Checking which now will slightly save process required space.
*Fixed "Custom Hero" Section where the "ADD" button malfuctioned
*Can now capture lastly used Section. In which when you exit this tool, it will save the current tab and make it as the default tab that will be opened on the next use of this Tool.

v1.4.0
*Added "Cursor-Pack" Feature at "Miscellaneous" Section
*Reorganized the "Miscellaneous" Section,dividing it into FOUR Sections: Single Source,Multi-Styles,Multi-Source,Optional Features.
*Fixed the Bug where the "HUD-Skin" writes incorrectly at "items_game.txt" causing "battlepass is missing failed to load items_def" ERROR when launching DOTA2.

v1.3.5
*Recompiled into a more stable Analyzer script.

v1.3.4
*Fixed a bug : If players installed their steam on a specific path... But Suddenly Relocate it to another Location, The Registry Location will not be valid anymore. : So for those Player who have done that, Relocate your DOTA2 path Manually!

v1.3.3
*Reworked Taunts setting it as "baseitem=1"

v1.3.2
*Fixed A bug where autoextract and gameinfo.gi auto-editing malfunctions because of the newly reworked method of detecting the dota 2 directory.

v1.3.1
*Reworked the Detection of the DOTA2 Directory. Deflecting the Encryption of "appmanifest.acf", in other words this tool will not read appmanifest anymore.

v1.3.0
*Added "Low-Processor Mode" at Advanced Section for those users who uses Low Processor Machines(2gb RAM below)

v1.2.0
*Added "Remove MOD on DOTA2" feature at "Advanced" section

v1.1.0
*Added "Music-Pack" feature at "Miscellaneous" section
*Fixed the bug where at general section,pressing "inject all actived id's" pops up multiple command prompts instead of hiding it.
*Added the Detection of DOTA2 Registry Folder(for users that installed DOTA2 before the birth of DOTA2 BETA)
*when "Auto-shutnik method" is turned off. It will now generate a "pak01_dir" folder including all cosmetic items plus items_game.txt. This option is best for MODDERs who wants to MANUALLY MOD DOTA2.

v1.0.2
*Fixed the bug where instead a cosmetic item should be renamed as ".vmdl_c", it was renamed as ".vmdl"(without _c) resulting arcana sets to malfunction

v1.0.1
*Universally fixes all dislocations of cosmetic items.
*Improved the detection of both default item and injected item when extracting .vmdl files at pak01_dir folder.
*Added the Detection of Cosmetic Particles, which fixes the bug which particle effects do not work online.

v1.0.0
*Added the "HLLIB" Plugin which allows this tool to have the ability to extract cosmetic items from the original "pak01_dir.vpk" at steam folder. This Fixes the items injected to not show up online.
*Relocates some settings to the "NEW Section" which is the "Advance" Section,this section is optional for ADVANCE USERS who knows what they are doing
*Makes this Tool even more interactive to Users

v0.1.1
*Fixed the BUG which the MOD does not show up ingame. This bug was caused by the new "auto-detection of gameinfo.gi"

v0.1.0
*Added "Titan's Anchor Logic" that allows this Tool to change its size or be maximized.
*Maintainably Fixed "auto_vpk.bat ERROR cannot be executed because it does not exist".

v0.0.1
*Added "Miscellaneous" Section. This section is revolutional which supports multiple features:
-Terrain Select
-Weather Effect Select
-HUD-Skin Select
-Courier Select(supports changable styles)
-Ward Select(supports changable styles)
-Loading-Screen Select
-Taunt for Heroes Select
-Announcer and Mega-Kills Select
-Activate Pet "Almond the Frondillo"
*Added "Auto-Shutnik Method" Feature at "Miscellaneous" Section which allows this script to do all the work activating the "MOD" without requiring you to study "Shutnik Method". But this feature crucially requires "VPKCreator"(you can download it at the internet if its not present just search "dota2 vpkcreator") or else this feature will be disabled. ACTIVATING THIS FEATURE DOES NOT REQUIRE THE "Use Miscellaneous on Future Injection" TO BE ENABLED, but ofcourse you need to locate the location of "gameinfo.gi". It is commonly located at "C:\Program Files (x86)\Steam\steamapps\common\dota 2 beta\game\dota\" Folder.
*Improved the Speed of Item Scanning by 50`%, in other words, if its slower for you. Then that constant speed is the fastest scan this application can do. SO HAVE PATIENCE!



~~~~~~~~~~~FACTS~~~~~~~~~~~



*Right-Click an item to change "Styles"(if it has an available alternative style).

*At "Handy Injection>Hero Items Selection" Section,every Hero can ONLY have ONE ITEM PER ITEM SLOT. Adding a "Check" Mark on an item will REMOVE THE OTHER CHECK MARK ON AN ITEM WITH THE SAME ITEM SLOT(eg. juggernaut's bladeform legacy is an Head Item slot, it will deselect any item that are Head Item Slot Like Mask of a Thousand Faces).

*On every Dropdownlist(eg. The Custom Items Location Path Found at the General Section... The gameinfo.gi Location Path found at the Advanced Section), to clear the control just left click the dropdownlist and left click the location path. This will clear the location path and disable its future controls.

*To Manually Patch gameinfo.gi using the injector, go to "advanced>patch gameinfo.gi". Clicking this button will Activate the MOD(pak01_dir.vpk) found at "%dota2dir%\" Folder.

*It is good that "use miscellaneous on future injection" Feature at "Miscellaneous" Section is "TURNED OFF" if you do not use any feature on that section. Because every start, this Tool will need to preload all miscellaneous assets which will consume much time

*"AUTO-SHUTNIK METHOD" is a very important feature of this Tool,it was built for users who dont know how to "Manually MOD DOTA2".

*Turning Off "AUTO-SHUTNIK METHOD" will Generate a "pak01_dir" folder at the "Generated MOD" Folder found on the same folder of this Tool. This is HELPFUL for users who wants to MANUALLY MOD DOTA2

*Turning ON "Low-Processor Mode" at "Advanced" Section will command this Tool not to consume alot of RAM when "Injecting items", executing only ONE COMMAND PROMPT to execute the Extraction of Items through their specific locations. BUT AS PENALTY, it will CONSUME ALOT OF TIME for the Injection to Finish!!! So if you are "Injecting 400 items"... I appoximate each items will be extracted after "5 seconds", so 400 x 5 is equal to 2000 seconds(33 minutes)

*"Save Settings" button on the bottom left does NOT SAVE DATALISTS,it only saves "directories" which you selected and checkboxes that are not inside a "DATALIST". If you want to save a Datalist. Use "Save DataBase List" instead.

*"Save DataBase List" at "Hero Items Selection" and "Used Items Database" from Handy Injection Section do the same thing.

*"Save DataBase List" at the "General" Section is different on "Save DataBase List" for "Handy Injection". In other words, it only saves the datalist PRESENT ON THAT SECTION PLUS ALL Miscellaneous DATALIST(if enabled).

*"Migration" Feature only prioritize items with "prefab=default_item". In other words, it does not support "terrain,weather,hud,loadingscreen,ect"

*At "Search" Section,You can press "Enter/Return" Key and it will do the same job pressing "Search for(keyword)" button.

*Pressing "Search for(keyword)" Button(Or Enter/Return) with the same "Keyword" you have searched last time will move to the next occurence... Until there is no match found`, it will go back to the very first occurence.

*The "ERROR LOG" at "Advanced" Section reports certain coincidence that is rarely different from what the injector has scanned before the last launch. This happens when a new update comes out with newly added cosmetic items, those items are registered at the "items_game.txt" that have unique ID's that not present on the earlier patches. But sometimes, they are REGISTERED AT AN EXISTED ID... While the OLD REGISTERED item on that ID that was REPLACED by this newly arrived item`,was MOVED INTO ANOTHER UNIQUE ID!!! So this Tool will able to detect those coincidence WHEN YOU HAVE A DATABASE.

*Expect that when an "ITEM was Announced" at the "ERROR LOG",it will be UNCHECKED at either "Handy Injection" section or "General" Section, in other words it will be unused. You need to "recheck" it again on that section to "Activate" it again.

*This Tool detects the DOTA2 Directory by pairing a combination pattern... It scans all Folder inside the "steamapps\common" then scans if the picked folder has "game\dota" subfolder inside.

*The Injector needs 150MB of RAM when making its Operation. If your computer is very weak to handle this amount of memory, then please do not use this injector and Throw this Tool at your Recycle Bin!



~~~~~~~~~~~TUTORIALS~~~~~~~~~~~



*General Section: https://www.youtube.com/watch?v=N8POaZ2nXbA&t=25s

*Handy Injection Section: https://www.youtube.com/watch?v=-BETnaBBLME&t=25s

*Miscellaneous Section: https://www.youtube.com/watch?v=y9HYHBtBYXs&t=834s

*External Files: https://www.youtube.com/watch?v=eG2XRCj7Sy0&t=365s

*Create your Own Database: https://www.youtube.com/watch?v=kC1-2UtXp_U

*Edit a Database: https://www.youtube.com/watch?v=wF2DnfrgWkg

*ERROR! Items_game.txt is missing!: https://www.youtube.com/watch?v=l4w2fT_lY10&t=3s



~~~~~~~~~~~CREDITS~~~~~~~~~~~



This are lifetime credits to those people who suffered bugs and are concerned to report to us. Making this tool More better every time!

v2.1.0
*7u7u74n9- inspected a bug where the injector only extracts npc_dota assets. Eg. Spirits of the Mothbinder's vmdl counterpart is "dota_death_prophet_exorcism_spirit" that has no "npc" at the beggining, making the injector to ignore this asset.

v2.0.0
*Alpha Bravo- as I currently use his "WM_MOUSEMOVE" Function.
*Obi-Wahn- for his "LV_MoveRow" Function that is integrated on this tool.
*Pulover [Rodolfo U. Batista]- for his "Eval" Function that I currently used evaluating strings into numbers.
*V for Vendetta- for his "VarWrite" and "VarRead" Function.


v1.7.2
*Klark92-as I currently use his "Draw" Function

v1.6.1
*7u7u74n9-inspected how the injector generates all files and confirmed its inaccuracy. Reported main cost problems including missing .vmdl files extracted at pak01_dir, Alternate Models(for three level grow of tiny,night stalker at night,terrorblade's demon form,lycan's shapeshift,lone druid' druid form,ect) failed to extract. Suggested Keyholes and some details.

v1.3.4
*Kush Manek-reported the bug where when he relocated his steam folder to another path,the tool cant identify the location anymore. Concluding "Cats are not good on hide and seek".

v1.0.1
*John Kris Uytiepo-reported specific heroes which has bugs which the items does not show when playing online. This Bug was fixed by optimizing detection to prevent dislocations on its specific location.

v0.1.1
*Edwin Santos-reported the bug of not showing items even if a good procedure was met.

v0.1.1
*Titan-as I currently use his "Anchor" Logic Function
