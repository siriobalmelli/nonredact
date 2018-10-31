---
title: Security of Access Cards
author: Sirio Balmelli
date: 2018-07-24
fontfamily: cmbright
fontsize: 14pt
papersize: A4
geometry: top=2.5cm,bottom=2.5cm,left=2.7cm,right=2.5cm
header-includes:
 - \usepackage{fancyhdr}
 - \pagestyle{myheadings}
 - \lhead{}
 - \chead{}
 - \rhead{\thepage}
 - \lfoot{}
 - \cfoot{}
 - \rfoot{}
 - \setlength{\parskip}{10pt plus 2pt minus 3pt}
#toc: 1
linestretch: 1.05
---
# Security of RFID and barcode access cards

This is a summary write-up of some security points regarding
RFID (Radio Frequency ID) and barcode (visual scanning) access cards.

Accidental breaches of security with these cards
	commonly occur as a result of:

1. Physical loss or removal

1. Unauthorized copy of
	- visual elements (barcode, photo)
	- RF elements (card ID)

This document merely contains observations and OpSec (Operational Security)
	considerations with regards to access cards; it is not intended as a:

-	comprehensive study
-	product review or endorsement
- 	recommendation of action
-	guarantee of any sort

While it is hoped this might be useful, please verify all information yourself
	and use at your own risk: the author makes no guarantees.

## Physical Loss or Removal

This occurs when there is no securing lanyard or other physical attachment
	to the body of the wearer; or when this attachment breaks.

1. "Mountaineering-style" clips which are not load-rated can open with slight sideways pressure:
	- ![weak_clip](weak_clip.jpg)

1. Brittle plastic badge-holders can crack, detaching from the security lanyard:
	- ![brittle_holder](brittle_holder.jpg)

1. Certain "security" lanyards have very weak plastic opening clips:
	- ![opening_lanyard](opening_lanyard.jpg)

1. Belt loops are fragile and can fail under low tension:
	- ![belt_loop](belt_loop.jpg)

## Physical Security Recommendations

1. Choose a badge holder with a thick attachment point:
	- ![thick_attachment](thick_attachment.jpg)

1. Attach lanyard to badge holder with two connections:
	- first attach the lanyard clip:
	- ![attach_clip](attach_clip.jpg)
	- then loop the lanyard inside itself to secure the holder:
	- ![loop_lanyard_a](loop_lanyard_a.jpg)
	- ![loop_lanyard_b](loop_lanyard_b.jpg)
	- ![loop_lanyard_c](loop_lanyard_c.jpg)
	
1. Attach lanyard to full belt (not belt loop)
	by looping inside itself (same technique):
	- ![loop_belt](loop_belt.jpg)
	
1. Alternately, use a load-bearing clip, such as a luggage-securing clip
	or an *actual* mountaineering clip:
	- ![load_clip](load_clip.jpg)
	
1. Secure clip around the full belt, not a belt loop:
	- ![load_belt](load_belt.jpg)

## Data Copying

1. Photos can be taken of a barcode and zoomed in digitally:
	- ![zoomed_photo](zoomed_photo.jpg)

1. An RFID card can be scanned at a distance.
High-powered scanners can scan from several feet away,
such as from inside a backpack in an adjacent cafe table:
	- ![distance_scan](distance_scan.jpg)

## Data Protection

1. Use an opaque badge holder that can hide barcodes when not in use:
	- ![hide_barcode_a](hide_barcode_a.jpg)
	- ![hide_barcode_b](hide_barcode_b.jpg)

1. Use an RFID-blocking badge holder.
The company `Specialist ID` makes one which seems effective under test:
	- ![RFID_blocker](RFID_blocker.jpg)
	- Placing the card onto the holder (without sliding it inside)
		is sufficient to block reads:
	- ![read_block](read_block.jpg)

### A Note on "RFID blocking" accessories

A lot of badge holders, purses, wallets, etc will claim to be "RFID blocking"
  but will not *actually* block RFID readings.

There are only a few *properly* designed products on the market;
	contrary to popular belief tinfoil is useless in blocking RFID.
	
Here are examples of these products:

1. Go Travel RFID Money Belt:
	- ![money_belt](money_belt.jpg)

1. Generic RFID-blocking badge holder:
	- ![generic_holder](generic_holder.jpg)

1. (expensive) Tumi RFID wallet:
	- ![tumi_wallet](tumi_wallet.jpg)
