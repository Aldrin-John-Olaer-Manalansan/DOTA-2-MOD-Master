# RA2YR MIX Unprotector MASTER

------------

<div align="center">
<b>About</b></div>

***RA2YR MIX Unprotected Master is a powerful tool designed to UNPROTECT MIX file headers, these will allow any PROTECTED MIX files to be openable by XCC Mixer Utility.***

------------

<div align="center">
<b>Trivia</b></div>

- What is a .mix File?
 - it is a Compressed File like ".zip/.rar" used by RA2/RA2YR to store all of their crucial files in one place. It is the ART of being ORGANIZED!

- What is MIX Protection?
 - MIX Protection means CORRUPTING the MIX file's HEADER, so that NOOBS trying to open .mix files in order to STEAL the works of other people will have some trouble over it.

- What is MIX Unprotection?
 - MIX Unprotection means RECOVERING the MIX file's HEADER, so that "WhiteHat Hackers" can troubleshoot some problems stored on a MIX File.

------------

<div align="center">
<b>Usage</b></div>

- Add a Target File - Browse a Target file with a respective extension(eg .mix) that will be added on the Target List ->

- Add a Target Folder - Browse a folder and scans for any existing file that has the respective extension(eg .mix) to be added on the Target File List ->

- Target File List - It automatically Detects if a File's Header(eg .mix) is PROTECTED. It also filters any UNPROTECTED Files, removing them from the list.

- Target Extension - This Extension will be automatically scanned when selecting a "Target Folder".

- Unprotect all Target Files - Will UNPROTECT all CHECKED Targets on the List.

- MIX File Attributes Exclusion - there are four types of header attribute settled at its 3rd byte:

> 00(Expansion) - Inside this mix file are expansion mixes included to the game(first became possible when Yuri's Revenge was released)

> 01(CheckSummed)- Has a unique header and footer algorithm detecting if there are ERRORS/CORRUPTION on each file stored on the MIX

> 02(Encrypted) - Compacted the MIX, making it size even more smaller. But is HEADER DEPENDENT, meaning having a BAD Header will crash RA2YR

> 03(Local) - Files that existed on RA2(without expansion), although its Algorithm for calculating the header is still unknown. HAVING A BAD HEADER WILL also CRASH RA2YR.

CheckSummed, Encrypted, and Local are almost untouchable(invulnerable to protection) meaning MIX files having this three attributes are automatically UNPROTECTED.
You can UNCHECK this parameters to include them on scans(UNRECOMMENDED but still works).
